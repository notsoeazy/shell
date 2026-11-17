import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland
import qs.config
import qs.theme

PanelWindow {
    id: root

    readonly property int effectiveThickness: Config.border.enabled ? Math.max(0, Config.border.thickness) : 0
    readonly property real inset: Math.min(effectiveThickness, width / 2, height / 2)
    readonly property real innerRadius: Math.max(0, Math.min(Config.border.radius, (width - 2 * inset) / 2, (height - 2 * inset) / 2))

    visible: effectiveThickness > 0
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Top

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            fillColor: Theme.colors.m3surface
            fillRule: ShapePath.OddEvenFill
            strokeWidth: -1
            startX: 0
            startY: 0

            PathLine {
                x: root.width
                y: 0
            }

            PathLine {
                x: root.width
                y: root.height
            }

            PathLine {
                x: 0
                y: root.height
            }

            PathLine {
                x: 0
                y: 0
            }

            PathMove {
                x: root.inset + root.innerRadius
                y: root.inset
            }

            PathLine {
                x: root.width - root.inset - root.innerRadius
                y: root.inset
            }

            PathArc {
                x: root.width - root.inset
                y: root.inset + root.innerRadius
                radiusX: root.innerRadius
                radiusY: root.innerRadius
                direction: PathArc.Clockwise
            }

            PathLine {
                x: root.width - root.inset
                y: root.height - root.inset - root.innerRadius
            }

            PathArc {
                x: root.width - root.inset - root.innerRadius
                y: root.height - root.inset
                radiusX: root.innerRadius
                radiusY: root.innerRadius
                direction: PathArc.Clockwise
            }

            PathLine {
                x: root.inset + root.innerRadius
                y: root.height - root.inset
            }

            PathArc {
                x: root.inset
                y: root.height - root.inset - root.innerRadius
                radiusX: root.innerRadius
                radiusY: root.innerRadius
                direction: PathArc.Clockwise
            }

            PathLine {
                x: root.inset
                y: root.inset + root.innerRadius
            }

            PathArc {
                x: root.inset + root.innerRadius
                y: root.inset
                radiusX: root.innerRadius
                radiusY: root.innerRadius
                direction: PathArc.Clockwise
            }

        }

    }

    mask: Region {
    }

}
