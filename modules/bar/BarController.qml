import QtQuick
import qs.components
import qs.config
import qs.modules.bar.sheets

// Coordinates the persistent bar and the current sheet without replacing the clock.
Item {
    id: root
    property bool headerShown: true
    readonly property bool requestedSheetReady: BarState.activeSheet !== ""
        && sheet.sheetName === BarState.activeSheet && sheet.ready
    readonly property bool sheetGeometry: requestedSheetReady || sheet.opacity > 0
    readonly property real sheetWidth: sheet.contentWidth
    readonly property real sheetHeight: sheet.contentHeight
    readonly property bool sheetInteractive: requestedSheetReady && !headerShown && header.opacity <= 0
    readonly property bool sheetWantsKeyboard: sheetInteractive && sheet.wantsKeyboard

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
        function onActiveSheetChanged(): void { root.advance() }
    }

    BarContent {
        id: header
        width: parent.width
        height: Math.min(parent.height, BarState.showDetails ? 88 : Config.bar.barHeight)
        enabled: BarState.activeSheet === ""
        opacity: root.headerShown ? 1 : 0
        visible: opacity > 0
        Behavior on opacity {
            Anim { duration: Tokens.animDuration.effectsFast; easing.bezierCurve: Tokens.animCurve.effectsFast }
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
        onOpacityChanged: if (opacity <= 0) root.advance()
        Behavior on opacity {
            Anim { duration: Tokens.animDuration.effectsFast; easing.bezierCurve: Tokens.animCurve.effectsFast }
        }
    }
    Component.onCompleted: advance()
}
