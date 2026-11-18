import QtQuick
import qs.components
import qs.config
import qs.modules.osd
import qs.services

// Coordinates the persistent bar and the current sheet without replacing the clock.
Item {
    id: root
    property bool headerShown: true
    property bool fullscreen: false
    property bool geometryReady: true
    property string displayMode: "normal"
    property string contentMode: "normal"
    property real transitionStartWidth: width
    property real transitionStartHeight: height
    readonly property real osdX: osd.x
    readonly property real osdY: osd.y
    readonly property real osdInputWidth: osd.width
    readonly property real osdInputHeight: osd.height
    readonly property bool osdInputEnabled: contentMode === "osd" && Osd.active && Osd.adjustable
    readonly property bool osdGeometry: displayMode === "osd"
    readonly property real osdWidth: osd.implicitWidth
    readonly property bool requestedSheetReady: BarState.activeSheet !== "" && sheet.sheetName === BarState.activeSheet && sheet.ready
    readonly property bool sheetGeometry: requestedSheetReady || sheet.opacity > 0
    readonly property real sheetWidth: sheet.contentWidth
    readonly property real sheetHeight: sheet.contentHeight
    readonly property bool sheetInteractive: requestedSheetReady && !headerShown && header.opacity <= 0 && !Osd.active && root.contentMode === "normal" && !root.fullscreen
    readonly property bool sheetWantsKeyboard: BarState.activeSheet !== "" && !root.fullscreen && (!requestedSheetReady || sheet.wantsKeyboard)
    readonly property real clockPixelSize: header.clockPixelSize
    readonly property bool clockVisible: header.opacity > 0.99 && contentMode === "normal" && !fullscreen && BarState.activeSheet === ""

    function clockSceneRect(): rect {
        return header.clockSceneRect();
    }

    function syncPresentation(): void {
        const desired = Osd.active ? "osd" : "normal";
        if (contentMode !== "none" && contentMode !== desired) {
            contentMode = "none";
            Qt.callLater(syncPresentation);
            return;
        }
        if (contentMode !== "none")
            return;
        if (header.opacity > 0 || sheet.opacity > 0 || osd.opacity > 0)
            return;
        if (displayMode !== desired) {
            transitionStartWidth = width;
            transitionStartHeight = height;
            displayMode = desired;
            Qt.callLater(syncPresentation);
            return;
        }
        if (!geometryReady)
            return;
        contentMode = desired;
    }
    onGeometryReadyChanged: if (geometryReady)
        Qt.callLater(syncPresentation)
    Binding {
        target: Osd
        property: "awaitingPresentation"
        value: Osd.active && root.contentMode !== "osd"
    }
    Connections {
        target: Osd
        function onActiveChanged(): void {
            root.syncPresentation();
        }
    }

    function advance(): void {
        const requested = BarState.activeSheet;
        if (requested === "") {
            if (sheet.opacity <= 0) {
                sheet.release();
                headerShown = true;
            }
        } else if (sheet.sheetName !== requested) {
            if (sheet.opacity <= 0)
                sheet.prepare(requested);
        } else if (sheet.ready) {
            headerShown = false;
        }
    }

    Connections {
        target: BarState
        function onActiveSheetChanged(): void {
            root.advance();
        }
    }

    BarContent {
        id: header
        width: parent.width
        height: Math.min(parent.height, Math.max(88, Config.bar.barHeight))
        enabled: BarState.activeSheet === ""
        opacity: root.headerShown && root.contentMode === "normal" && !root.fullscreen ? 1 : 0
        visible: opacity > 0
        onOpacityChanged: if (opacity <= 0)
            root.syncPresentation()

        Behavior on opacity {
            Anim {
                duration: Tokens.animDuration.effectsQuick
                easing.bezierCurve: Tokens.animCurve.effectsFast
            }
        }
    }

    SheetController {
        id: sheet
        x: Tokens.padding.lg
        y: Tokens.padding.lg
        width: Math.max(0, root.width - 2 * Tokens.padding.lg)
        height: contentHeight
        interactive: root.sheetInteractive
        enabled: interactive
        visible: opacity > 0 || interactive
        opacity: root.sheetInteractive ? 1 : 0
        onReadyChanged: Qt.callLater(root.advance)
        onOpacityChanged: if (opacity <= 0) {
            root.advance();
            root.syncPresentation();
        }
        Behavior on opacity {
            Anim {
                duration: Tokens.animDuration.effectsQuick
                easing.bezierCurve: Tokens.animCurve.effectsFast
            }
        }
    }

    OsdView {
        id: osd
        anchors.centerIn: parent
        width: Math.min(implicitWidth, Math.max(0, parent.width - 2 * Tokens.padding.lg))
        height: implicitHeight
        interactive: root.osdInputEnabled
        opacity: root.contentMode === "osd" && Osd.active ? 1 : 0
        visible: opacity > 0
        onOpacityChanged: if (opacity <= 0)
            root.syncPresentation()
        Behavior on opacity {
            Anim {
                duration: Tokens.animDuration.effectsQuick
                easing.bezierCurve: Tokens.animCurve.effectsFast
            }
        }
    }

    Component.onCompleted: advance()
}
