import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland as NativeHypr
import qs.config
import qs.components

PanelWindow {
    id: root

    WlrLayershell.keyboardFocus: barController.sheetWantsKeyboard ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    Component.onCompleted: BarState.pulse()

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    BarContainer {
        id: bar

        x: (root.width - width) / 2
        y: Config.bar.notchMode ? 0 : Math.max(0, Config.bar.screenGap)
        targetWidth: Math.max(40, Math.min(root.width - 40, barController.sheetGeometry ? barController.sheetWidth + 2 * Tokens.padding.lg : BarState.headerMode === "expanded" ? 560 : BarState.headerMode === "default" ? 440 : Config.bar.idleWidth))
        targetHeight: barController.sheetGeometry ? Math.min(root.height - Math.max(0, bar.y), barController.sheetHeight + 2 * Tokens.padding.lg) : BarState.showDetails ? 88 : Config.bar.barHeight

        HoverHandler {
            onHoveredChanged: {
                if (hovered)
                    BarState.pointerEntered();
                else
                    BarState.pointerExited();
            }
        }

        BarController {
            id: barController
            anchors.fill: parent
        }

        Behavior on y {
            Anim {
                duration: Tokens.animDuration.spatial
                easing.bezierCurve: Tokens.animCurve.spatial
            }

        }

    }

    NativeHypr.HyprlandFocusGrab {
        active: BarState.activeSheet !== ""
        windows: [root]
        onCleared: BarState.closeSheet()
    }

    IpcHandler {
        target: "launcher"
        function toggle(): void { BarState.toggleLauncher() }
        function open(): void { BarState.openLauncher() }
        function close(): void { BarState.closeSheet() }
    }

    BarPulses {}

    // The input region follows the animated bar, leaving the rest click-through.
    mask: Region {
        x: Math.floor(bar.x)
        y: Math.floor(bar.y)
        width: Math.ceil(bar.x + bar.width) - Math.floor(bar.x)
        height: Math.ceil(bar.y + bar.height) - Math.floor(bar.y)
    }

}
