import QtQuick
import qs.components
import qs.config
import qs.services as Services
import qs.theme

Item {
    id: root

    readonly property int count: Math.max(1, Config.bar.workspaceCount)
    readonly property int pageStart: Math.floor((Math.max(1, Services.Hyprland.active) - 1) / count) * count
    readonly property int activeIndex: Services.Hyprland.active - pageStart - 1
    readonly property real dot: 8
    readonly property real gap: Tokens.spacing.sm
    readonly property real extra: Tokens.spacing.md
    readonly property real step: dot + gap

    function slotX(index: int) : real {
        return index * step + (index > activeIndex ? extra : 0);
    }

    implicitWidth: count * step - gap + extra
    implicitHeight: 20

    Repeater {
        model: root.count

        delegate: Item {
            id: slot

            required property int index
            readonly property int workspaceId: root.pageStart + index + 1

            x: root.slotX(index)
            width: index === root.activeIndex ? root.dot + root.extra : root.dot
            height: root.height

            Rectangle {
                anchors.centerIn: parent
                width: root.dot
                height: root.dot
                radius: height / 2
                visible: slot.index !== root.activeIndex
                color: Services.Hyprland.occupied.includes(slot.workspaceId) ? Theme.colors.m3onSurfaceVariant : Theme.colors.m3outline
            }

            TapHandler {
                onTapped: Services.Hyprland.focus(slot.workspaceId)
            }

            Behavior on x {
                Anim {
                    duration: Tokens.animDuration.spatialFast
                    easing.bezierCurve: Tokens.animCurve.spatialFast
                }

            }

        }

    }

    Rectangle {
        x: root.activeIndex * root.step
        anchors.verticalCenter: parent.verticalCenter
        width: root.dot + root.extra
        height: root.dot
        radius: height / 2
        visible: root.activeIndex >= 0 && root.activeIndex < root.count
        color: Theme.colors.m3primary

        Behavior on x {
            Anim {
                duration: Tokens.animDuration.spatialFast
                easing.bezierCurve: Tokens.animCurve.spatialFast
            }

        }

    }

}
