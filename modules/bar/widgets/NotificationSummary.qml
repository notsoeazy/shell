import QtQuick
import qs.components
import qs.config
import qs.theme

Item {
    id: root

    // A negative count means no notification service has supplied a count yet.
    property int count: -1
    readonly property string summary: count < 0 ? "Notifications" : count === 0 ? "All caught up" : count === 1 ? "1 notification" : `${count} notifications`

    implicitWidth: label.implicitWidth + Tokens.spacing.sm + bell.implicitWidth
    implicitHeight: Math.max(label.implicitHeight, bell.implicitHeight)
    clip: true

    Text {
        id: label

        width: Math.max(0, root.width - bell.width - Tokens.spacing.sm)
        anchors.verticalCenter: parent.verticalCenter
        text: root.summary
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignRight
        color: Theme.colors.m3onSurfaceVariant
        font.family: Tokens.fontFamily.sans
        font.pixelSize: Tokens.fontSize.md
    }

    Icons {
        id: bell

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        text: "bell"
        size: Tokens.iconSize.lg
        filled: true
        color: Theme.colors.m3onSurfaceVariant
    }

}
