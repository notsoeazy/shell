import QtQuick
import QtQuick.Shapes
import qs.components
import qs.config
import qs.theme

Item {
    id: root

    default property alias content: contentLayer.data
    property real targetWidth: 150
    property real targetHeight: 44
    property real bodyWidth: targetWidth
    property real bodyHeight: targetHeight
    property real shoulder: Config.bar.notchMode ? 1 : -1
    readonly property real radius: Math.min(20, bodyWidth / 2)
    readonly property real radiusY: Math.min(radius, bodyHeight / 2)
    readonly property real cornerX: Math.max(0.01, radius * Math.abs(shoulder))
    readonly property real cornerY: Math.max(0.01, radiusY * Math.abs(shoulder))
    readonly property int cornerSweep: shoulder >= 0 ? PathArc.Clockwise : PathArc.Counterclockwise

    width: bodyWidth + radius * 2
    height: bodyHeight

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            fillColor: Theme.colors.m3surface
            strokeWidth: -1
            startX: root.radius * (1 - root.shoulder)
            startY: 0

            PathArc {
                relativeX: root.radius * root.shoulder
                relativeY: root.cornerY
                radiusX: root.cornerX
                radiusY: root.cornerY
                direction: root.cornerSweep
            }

            PathLine {
                relativeX: 0
                relativeY: root.bodyHeight - root.radiusY - root.cornerY
            }

            PathArc {
                relativeX: root.radius
                relativeY: root.radiusY
                radiusX: root.radius
                radiusY: root.radiusY
                direction: PathArc.Counterclockwise
            }

            PathLine {
                relativeX: root.bodyWidth - root.radius * 2
                relativeY: 0
            }

            PathArc {
                relativeX: root.radius
                relativeY: -root.radiusY
                radiusX: root.radius
                radiusY: root.radiusY
                direction: PathArc.Counterclockwise
            }

            PathLine {
                relativeX: 0
                relativeY: -(root.bodyHeight - root.radiusY - root.cornerY)
            }

            PathArc {
                relativeX: root.radius * root.shoulder
                relativeY: -root.cornerY
                radiusX: root.cornerX
                radiusY: root.cornerY
                direction: root.cornerSweep
            }
        }
    }

    Item {
        id: contentLayer

        x: root.radius
        width: root.bodyWidth
        height: root.bodyHeight
        clip: true
    }

    Behavior on bodyWidth {
        Anim {
            duration: Tokens.animDuration.spatial
            easing.bezierCurve: Tokens.animCurve.spatial
        }
    }

    Behavior on bodyHeight {
        Anim {
            duration: Tokens.animDuration.spatial
            easing.bezierCurve: Tokens.animCurve.spatial
        }
    }

    Behavior on shoulder {
        Anim {
            duration: Tokens.animDuration.spatial
            easing.bezierCurve: Tokens.animCurve.spatial
        }
    }
}
