import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.config

Scope {
    id: root

    property int borderThickness: 0
    readonly property int edgeReservation: borderThickness + Math.max(0, Config.border.spacing)

    PanelWindow {
        implicitHeight: 1
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Top
        exclusiveZone: root.edgeReservation + Math.max(0, Config.bar.barHeight) + (Config.bar.notchMode ? 0 : Math.max(0, Config.bar.screenGap))

        anchors {
            top: true
            left: true
            right: true
        }

        mask: Region {
        }

    }

    PanelWindow {
        implicitHeight: 1
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Top
        exclusiveZone: root.edgeReservation

        anchors {
            bottom: true
            left: true
            right: true
        }

        mask: Region {
        }

    }

    PanelWindow {
        implicitWidth: 1
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Top
        exclusiveZone: root.edgeReservation

        anchors {
            left: true
            top: true
            bottom: true
        }

        mask: Region {
        }

    }

    PanelWindow {
        implicitWidth: 1
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Top
        exclusiveZone: root.edgeReservation

        anchors {
            right: true
            top: true
            bottom: true
        }

        mask: Region {
        }

    }

}
