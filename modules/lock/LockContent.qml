import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.components
import qs.config
import qs.services
import qs.theme
import qs.utils

Item {
    id: root

    property bool travels: false
    property bool screenReady: false
    property bool entranceStarted: false
    property bool wallpaperReady: false
    property bool allowScreenFallback: false
    property bool travelAtStart: false
    property rect startRect: Qt.rect(0, 0, 0, 0)
    property real startPixelSize: 0
    property bool awake: false
    property real progress: 0
    property string pendingPath: ""
    property var dimensions: []
    readonly property bool settled: Lock.secure && !Lock.leaving
    readonly property point origin: travelAtStart ? Qt.point(startRect.x + startRect.width / 2, startRect.y + startRect.height / 2) : Qt.point(width / 2, 0)

    function focusInput(): void {
        Qt.callLater(() => password.forceActiveFocus());
    }
    function submitPassword(): void {
        if (!password.text.length) {
            awake = true;
            return;
        }
        const secret = password.text;
        password.clear();
        Lock.submit(secret);
    }
    function loadWallpaper(): void {
        if (metadataReader.running || width <= 0 || height <= 0)
            return;
        if (!Wallpapers.current) {
            wallpaperReady = true;
            startEntrance();
            return;
        }
        wallpaperReady = false;
        pendingPath = Wallpapers.current;
        dimensions = [];
        metadataReader.running = true;
    }
    function startEntrance(): void {
        if (!Lock.secure || entranceStarted || !wallpaperReady || (!screenReady && !allowScreenFallback))
            return;
        entranceStarted = true;
        travelAtStart = screenReady && travels;
        entrance.start();
    }
    onScreenReadyChanged: if (screenReady)
        startEntrance()
    onWidthChanged: if (!wallpaperReady && !metadataReader.running)
        loadWallpaper()
    onHeightChanged: if (!wallpaperReady && !metadataReader.running)
        loadWallpaper()
    Component.onCompleted: {
        loadWallpaper();
        focusInput();
        if (Lock.secure) {
            if (screenReady)
                startEntrance();
            else
                entranceFallback.restart();
        }
    }
    Connections {
        target: Wallpapers
        function onCurrentChanged(): void {
            if (!root.entranceStarted)
                root.loadWallpaper();
        }
    }
    Connections {
        target: Lock
        function onSecureChanged(): void {
            if (Lock.secure) {
                if (root.screenReady)
                    root.startEntrance();
                else
                    entranceFallback.restart();
                root.focusInput();
            }
        }
        function onCheckingChanged(): void {
            if (!Lock.checking && !Lock.leaving)
                root.focusInput();
        }
        function onFailed(): void {
            password.clear();
            root.awake = true;
            root.focusInput();
        }
    }
    Timer {
        id: entranceFallback
        interval: 250
        onTriggered: {
            root.allowScreenFallback = true;
            root.startEntrance();
        }
    }
    Process {
        id: metadataReader
        command: ["python3", Quickshell.shellPath("utils/wallpapers.py"), "dimensions", root.pendingPath]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.dimensions = JSON.parse(text);
                } catch (error) {
                    root.dimensions = [];
                }
            }
        }
        onExited: (code, status) => {
            if (root.pendingPath !== Wallpapers.current) {
                root.loadWallpaper();
                return;
            }
            let size = Qt.size(0, 0);
            if (code === 0 && root.dimensions.length === 2 && root.dimensions[0] > 0 && root.dimensions[1] > 0) {
                const scale = Math.min(Math.max(root.width * Screen.devicePixelRatio / root.dimensions[0], root.height * Screen.devicePixelRatio / root.dimensions[1]), 1);
                size = Qt.size(Math.max(1, Math.ceil(root.dimensions[0] * scale)), Math.max(1, Math.ceil(root.dimensions[1] * scale)));
            }
            wallpaper.sourceSize = size;
            wallpaper.source = FilePath.fileUrl(root.pendingPath);
        }
    }
    Rectangle {
        anchors.fill: parent
        color: Theme.colors.m3background
    }
    Image {
        id: wallpaper
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        autoTransform: true
        cache: false
        opacity: root.entranceStarted ? 1 : 0
        Behavior on opacity {
            Anim {
                duration: Tokens.animDuration.effectsSlow
                easing.bezierCurve: Tokens.animCurve.effectsSlow
            }
        }
        onStatusChanged: {
            if (status === Image.Ready || status === Image.Error) {
                root.wallpaperReady = true;
                root.startEntrance();
            }
        }
    }
    Rectangle {
        anchors.fill: parent
        color: "#66000000"
        opacity: root.settled ? 1 : 0
        Behavior on opacity {
            Anim {
                duration: Tokens.animDuration.effectsSlow
                easing.bezierCurve: Tokens.animCurve.effectsSlow
            }
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.awake = true;
            root.focusInput();
        }
    }
    Text {
        id: clock
        readonly property real startScale: root.startPixelSize > 0 ? root.startPixelSize / clock.font.pixelSize : 1
        readonly property real centerX: root.travelAtStart ? root.origin.x + (root.width / 2 - root.origin.x) * root.progress : root.width / 2
        readonly property real centerY: root.travelAtStart ? root.origin.y + (root.height * Tokens.lock.clockCenter - root.origin.y) * root.progress : root.height * Tokens.lock.clockCenter
        x: centerX - width / 2
        y: centerY - height / 2
        scale: root.travelAtStart ? startScale + (1 - startScale) * root.progress : 1
        opacity: root.entranceStarted && (root.travelAtStart || root.settled) ? 1 : 0
        Behavior on opacity {
            enabled: !root.travelAtStart
            Anim {
                duration: Tokens.animDuration.effects
                easing.bezierCurve: Tokens.animCurve.effects
            }
        }
        text: Time.format("hh:mm AP")
        color: Theme.colors.m3onSurface
        font.family: Tokens.fontFamily.sans
        font.pixelSize: Math.min(Tokens.lock.clockSize, Math.max(Tokens.fontSize.lg, (root.width - 2 * Tokens.padding.xl) / 6))
        font.weight: Tokens.fontWeight.semiBold
        font.variableAxes: ({
                "wght": Tokens.fontWeight.semiBold
            })
    }
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.height * Tokens.lock.clockCenter + clock.height / 2 + Tokens.spacing.sm
        text: Time.format("dddd, MMMM d")
        color: Theme.colors.m3onSurface
        font.family: Tokens.fontFamily.sans
        font.pixelSize: Tokens.fontSize.lg
        opacity: root.settled ? 1 : 0
        Behavior on opacity {
            Anim {
                duration: Tokens.animDuration.effects
                easing.bezierCurve: Tokens.animCurve.effects
            }
        }
    }
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.height * Tokens.lock.fieldCenter - password.height / 2
        spacing: Tokens.spacing.sm
        opacity: root.awake && root.settled ? 1 : 0
        Behavior on opacity {
            Anim {
                duration: Tokens.animDuration.effects
                easing.bezierCurve: Tokens.animCurve.effects
            }
        }
        TextField {
            id: password
            width: Math.min(Tokens.lock.fieldWidth, Math.max(1, root.width - 2 * Tokens.padding.xl))
            height: Tokens.lock.fieldHeight
            echoMode: TextInput.Password
            placeholderText: "Enter password"
            leftPadding: Tokens.padding.lg + Tokens.iconSize.md + Tokens.spacing.sm
            rightPadding: Tokens.padding.lg + Tokens.iconSize.md + Tokens.spacing.sm
            verticalAlignment: TextInput.AlignVCenter
            selectByMouse: true
            color: Theme.colors.m3onSurface
            placeholderTextColor: Theme.colors.m3onSurfaceVariant
            font.family: Tokens.fontFamily.sans
            font.pixelSize: Tokens.fontSize.md
            enabled: !Lock.checking && !Lock.leaving
            onTextChanged: if (text.length)
                root.awake = true
            onAccepted: root.submitPassword()
            Keys.onEscapePressed: {
                clear();
                root.awake = false;
            }
            Keys.onPressed: event => {
                if (event.key !== Qt.Key_Escape)
                    root.awake = true;
            }
            Icons {
                anchors.left: parent.left
                anchors.leftMargin: Tokens.padding.lg
                anchors.verticalCenter: parent.verticalCenter
                text: "lock-key"
                size: Tokens.iconSize.md
                color: Theme.colors.m3onSurfaceVariant
                bold: true
            }
            Icons {
                anchors.right: parent.right
                anchors.rightMargin: Tokens.padding.lg
                anchors.verticalCenter: parent.verticalCenter
                text: "arrow-right"
                size: Tokens.iconSize.md
                color: password.text.length ? Theme.colors.m3onSurface : Theme.colors.m3onSurfaceVariant
                bold: true
                MouseArea {
                    anchors.fill: parent
                    enabled: password.text.length > 0 && password.enabled
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.submitPassword()
                }
            }
            background: Rectangle {
                radius: height / 2
                color: Qt.alpha(Theme.colors.m3surfaceContainerHigh, 0.95)
                border.width: 1
                border.color: password.activeFocus ? Theme.colors.m3outline : Theme.colors.m3outlineVariant
                Behavior on border.color {
                    CAnim {}
                }
            }
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            width: password.width - 2 * Tokens.padding.md
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            text: Lock.checking ? "Checking…" : Lock.message || "Press Enter to unlock"
            color: Lock.message ? Theme.colors.m3error : Theme.colors.m3onSurfaceVariant
            font.family: Tokens.fontFamily.sans
            font.pixelSize: Tokens.fontSize.sm
            Behavior on color {
                CAnim {}
            }
        }
    }
    NumberAnimation {
        id: entrance
        target: root
        property: "progress"
        from: 0
        to: 1
        duration: Tokens.animDuration.spatialSlow
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Tokens.animCurve.spatialSlow
    }
}
