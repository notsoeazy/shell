import QtQuick
import Quickshell.Widgets
import qs.components
import qs.config
import qs.services
import qs.theme

Item {
    id: root

    readonly property real targetWidth: Osd.kind === "message" ? Math.min(Tokens.osd.maxMessageWidth, messageText.implicitWidth + Tokens.iconSize.md + 3 * Tokens.spacing.md) : Tokens.osd.width

    readonly property bool adjustable: Osd.active && Osd.adjustable
    property bool interactive: false
    readonly property bool dragging: pointer.pressed

    function seek(x: real): void {
        if (levelTrack.width > 0)
            Osd.adjust(x / levelTrack.width);
    }

    implicitWidth: targetWidth
    implicitHeight: Tokens.osd.height

    ClippingRectangle {
        id: levelTrack

        property real level: Osd.value

        anchors.centerIn: parent
        width: parent.width
        height: Tokens.osd.height
        radius: height / 2
        color: Theme.colors.m3surfaceContainerHighest
        visible: Osd.kind === "level"

        Rectangle {
            width: levelTrack.width * Math.max(0, Math.min(1, levelTrack.level))
            height: parent.height
            color: Theme.colors.m3primary
        }

        AnimatedIcon {
            anchors.left: parent.left
            anchors.leftMargin: Tokens.padding.sm
            anchors.verticalCenter: parent.verticalCenter
            text: Osd.icon
            bold: true
            size: Tokens.iconSize.md
            color: levelTrack.level * levelTrack.width > x + width / 2 ? Theme.colors.m3onPrimary : Theme.colors.m3onSurface
        }

        MouseArea {
            id: pointer
            anchors.fill: parent
            enabled: root.interactive && root.adjustable
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton
            preventStealing: true
            onPressed: mouse => {
                Osd.held = true;
                root.seek(mouse.x);
            }
            onPositionChanged: mouse => {
                if (pressed)
                    root.seek(mouse.x);
            }
            onReleased: Osd.held = false
            onCanceled: Osd.held = false
            onWheel: wheel => {
                const delta = wheel.angleDelta.y !== 0 ? wheel.angleDelta.y / 120 : wheel.pixelDelta.y / 40;
                if (delta !== 0) {
                    Osd.adjustBy(delta * 0.05);
                    wheel.accepted = true;
                }
            }
        }

        Behavior on level {
            Anim {
                duration: Tokens.animDuration.spatialFast
                easing.bezierCurve: Tokens.animCurve.spatialFast
            }
        }
    }

    Row {
        anchors.centerIn: parent
        spacing: Tokens.spacing.sm
        visible: Osd.kind === "message"

        AnimatedIcon {
            anchors.verticalCenter: parent.verticalCenter
            // Optical adjustment for the icon font relative to the message text.
            anchors.verticalCenterOffset: -1
            text: Osd.icon
            bold: true
            size: Tokens.iconSize.md
            color: Theme.colors.m3onSurface
        }

        Text {
            id: messageText

            anchors.verticalCenter: parent.verticalCenter
            width: Math.min(implicitWidth, Math.max(0, root.width - Tokens.iconSize.md - Tokens.spacing.sm))
            text: Osd.message
            textFormat: Text.PlainText
            elide: Text.ElideRight
            color: Theme.colors.m3onSurface
            font.family: Tokens.fontFamily.sans
            font.pixelSize: Tokens.fontSize.md
            font.weight: Tokens.fontWeight.medium
            font.variableAxes: ({
                    "wght": Tokens.fontWeight.medium
                })
        }
    }
}
