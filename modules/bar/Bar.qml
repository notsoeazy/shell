import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland as Hypr
import qs.config
import qs.components
import qs.services as Services

PanelWindow {
    id: root

    property int borderThickness: 0
    readonly property bool fullscreen: Services.Hyprland.fullscreen
    readonly property point osdOffset: barController.mapToItem(bar, barController.osdX, barController.osdY)
    readonly property point wallpaperOrigin: Qt.point(bar.x + bar.width / 2, bar.y + bar.height / 2)

    WlrLayershell.layer: WlrLayer.Overlay
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
        y: root.fullscreen ? Math.max(0, Config.bar.screenGap) : root.borderThickness + (Config.bar.notchMode ? 0 : Math.max(0, Config.bar.screenGap))
        shoulder: root.fullscreen ? -1 : Config.bar.notchMode ? 1 : -1
        opacity: root.fullscreen && !barController.osdGeometry ? 0 : 1
        enabled: !root.fullscreen || barController.osdInputEnabled
        targetWidth: Math.max(40, Math.min(root.width - 40, barController.osdGeometry ? barController.osdWidth + 2 * Tokens.padding.lg : barController.sheetGeometry ? barController.sheetWidth + 2 * Tokens.padding.lg : BarState.headerMode === "expanded" ? 560 : BarState.headerMode === "default" ? 440 : Config.bar.idleWidth))
        targetHeight: barController.osdGeometry ? Config.bar.barHeight : barController.sheetGeometry ? Math.min(root.height - Math.max(0, bar.y), barController.sheetHeight + 2 * Tokens.padding.lg) : BarState.showDetails ? 88 : Config.bar.barHeight

        HoverHandler {
            enabled: !root.fullscreen
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
            fullscreen: root.fullscreen
            geometryReady: Math.abs(bar.bodyWidth - bar.targetWidth) <= Math.max(1, Math.abs(barController.transitionStartWidth - bar.targetWidth) * 0.2) && Math.abs(bar.bodyHeight - bar.targetHeight) <= Math.max(1, Math.abs(barController.transitionStartHeight - bar.targetHeight) * 0.2)
        }

        Behavior on opacity {
            Anim {
                duration: Tokens.animDuration.effectsFast
                easing.bezierCurve: Tokens.animCurve.effectsFast
            }
        }

        Behavior on y {
            Anim {
                duration: Tokens.animDuration.spatial
                easing.bezierCurve: Tokens.animCurve.spatial
            }
        }
    }

    Hypr.HyprlandFocusGrab {
        active: BarState.activeSheet !== "" && !root.fullscreen
        windows: [root]
        onCleared: BarState.closeSheet()
    }

    BarPulses {}

    // The input region follows the animated bar, leaving the rest click-through.
    mask: Region {
        x: root.fullscreen ? Math.floor(bar.x + root.osdOffset.x) : Math.floor(bar.x)
        y: root.fullscreen ? Math.floor(bar.y + root.osdOffset.y) : Math.floor(bar.y)
        width: root.fullscreen ? (barController.osdInputEnabled ? Math.ceil(bar.x + root.osdOffset.x + barController.osdInputWidth) - x : 0) : Math.ceil(bar.x + bar.width) - Math.floor(bar.x)
        height: root.fullscreen ? (barController.osdInputEnabled ? Math.ceil(bar.y + root.osdOffset.y + barController.osdInputHeight) - y : 0) : Math.ceil(bar.y + bar.height) - Math.floor(bar.y)
    }
}
