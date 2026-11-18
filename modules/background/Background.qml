import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.config
import qs.services
import qs.theme
import qs.utils

PanelWindow {
    id: root

    property point revealOrigin: Qt.point(width / 2, 0)
    property point transitionOrigin: Qt.point(width / 2, 0)
    property bool frontIsA: true
    property bool revealing: false
    property bool resizeReload: false
    property real progress: 0
    property string desiredPath: Wallpapers.showing
    property string metadataPath: ""
    property var metadata: []
    readonly property var front: frontIsA ? layerA : layerB
    readonly property var back: frontIsA ? layerB : layerA
    readonly property real farthest: Math.max(Math.hypot(transitionOrigin.x, transitionOrigin.y), Math.hypot(width - transitionOrigin.x, transitionOrigin.y), Math.hypot(transitionOrigin.x, height - transitionOrigin.y), Math.hypot(width - transitionOrigin.x, height - transitionOrigin.y)) + 2

    function requestImage(): void {
        if (!desiredPath || width <= 0 || height <= 0 || revealing)
            return;
        if (!resizeReload && front.wallpaperPath === desiredPath && front.imageStatus === Image.Ready)
            return;
        if (metadataReader.running)
            return;
        metadataPath = desiredPath;
        metadata = [];
        metadataReader.running = true;
    }
    function loadImage(path: string, dimensions: var): void {
        if (path !== desiredPath || revealing)
            return;
        const screenWidth = Math.ceil(width * Screen.devicePixelRatio);
        const screenHeight = Math.ceil(height * Screen.devicePixelRatio);
        let size = Qt.size(0, 0);
        if (dimensions.length === 2 && dimensions[0] > 0 && dimensions[1] > 0) {
            const scale = Math.min(Math.max(screenWidth / dimensions[0], screenHeight / dimensions[1]), 1);
            size = Qt.size(Math.max(1, Math.ceil(dimensions[0] * scale)), Math.max(1, Math.ceil(dimensions[1] * scale)));
        }
        resizeReload = false;
        back.decodeSize = size;
        back.wallpaperPath = path;
        Qt.callLater(() => showLoaded(back));
    }
    function showLoaded(layer: var): void {
        if (revealing || layer !== back || layer.wallpaperPath !== desiredPath || layer.imageStatus !== Image.Ready)
            return;
        transitionOrigin = Qt.point(Math.max(0, Math.min(width, revealOrigin.x)), Math.max(0, Math.min(height, revealOrigin.y)));
        progress = 0;
        revealing = true;
        revealAnimation.to = 1;
        revealAnimation.start();
    }
    function changed(): void {
        requestDelay.restart();
    }
    onDesiredPathChanged: {
        if (!desiredPath) {
            requestDelay.stop();
            revealAnimation.stop();
            revealing = false;
            layerA.wallpaperPath = "";
            layerB.wallpaperPath = "";
        } else
            changed();
    }
    onWidthChanged: resizeDelay.restart()
    onHeightChanged: resizeDelay.restart()
    Component.onCompleted: requestDelay.restart()

    visible: Config.wallpaper.enabled
    color: Theme.colors.m3background
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Background
    mask: Region {}
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    Timer {
        id: requestDelay
        interval: 120
        onTriggered: root.requestImage()
    }
    Timer {
        id: resizeDelay
        interval: 200
        onTriggered: {
            root.resizeReload = true;
            root.requestImage();
        }
    }
    Process {
        id: metadataReader
        command: ["python3", Quickshell.shellPath("utils/wallpapers.py"), "dimensions", root.metadataPath]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.metadata = JSON.parse(text);
                } catch (error) {
                    root.metadata = [];
                }
            }
        }
        onExited: (code, status) => {
            if (requestDelay.running)
                return;
            if (root.metadataPath !== root.desiredPath)
                root.requestImage();
            else
                root.loadImage(root.metadataPath, code === 0 ? root.metadata : []);
        }
    }
    component WallpaperLayer: Item {
        property string wallpaperPath: ""
        property size decodeSize: Qt.size(0, 0)
        readonly property int imageStatus: picture.status
        anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            color: Theme.colors.m3background
        }
        Image {
            id: picture
            anchors.fill: parent
            source: parent.wallpaperPath ? FilePath.fileUrl(parent.wallpaperPath) : ""
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            autoTransform: true
            cache: false
            sourceSize: parent.decodeSize
            onStatusChanged: {
                if (status === Image.Ready)
                    Qt.callLater(() => root.showLoaded(parent));
                else if (status === Image.Error)
                    console.warn("Wallpapers: failed to load", parent.wallpaperPath);
            }
        }
    }
    WallpaperLayer {
        id: layerA
        z: root.frontIsA ? 0 : -1
    }
    WallpaperLayer {
        id: layerB
        z: root.frontIsA ? -1 : 0
    }
    ShaderEffectSource {
        id: revealSource
        sourceItem: root.back
        hideSource: true
        live: root.revealing
        visible: false
    }
    ShaderEffect {
        anchors.fill: parent
        z: 1
        visible: root.revealing
        property variant source: revealSource
        property vector2d viewportSize: Qt.vector2d(width, height)
        property vector2d origin: Qt.vector2d(root.transitionOrigin.x, root.transitionOrigin.y)
        property real radius: Math.max(0, Math.min(1, root.progress)) * root.farthest
        fragmentShader: Qt.resolvedUrl("../../assets/shaders/wallpaper-reveal.frag.qsb")
    }
    NumberAnimation {
        id: revealAnimation
        target: root
        property: "progress"
        duration: Tokens.animDuration.spatial
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Tokens.animCurve.spatial
        onFinished: {
            root.revealing = false;
            root.frontIsA = !root.frontIsA;
            root.back.wallpaperPath = "";
            if (!requestDelay.running)
                root.requestImage();
        }
    }
}
