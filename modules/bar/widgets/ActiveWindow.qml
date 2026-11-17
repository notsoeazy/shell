import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.components
import qs.config
import qs.services as Services
import qs.theme

Item {
    id: root

    readonly property int iconSize: Tokens.iconSize.lg
    readonly property string iconPath: Services.Hyprland.appIcon ? Quickshell.iconPath(Services.Hyprland.appIcon, true) : ""

    implicitWidth: iconSize + Tokens.spacing.sm + label.implicitWidth
    implicitHeight: Math.max(iconSize, label.implicitHeight)

    IconImage {
        id: appIcon

        width: root.iconSize
        height: root.iconSize
        anchors.verticalCenter: parent.verticalCenter
        source: root.iconPath
        visible: root.iconPath !== "" && status === Image.Ready
    }

    Icons {
        anchors.verticalCenter: parent.verticalCenter
        size: root.iconSize
        filled: true
        text: Services.Hyprland.activeWindow ? "app-window" : "desktop"
        color: Theme.colors.m3onSurfaceVariant
        visible: !appIcon.visible
    }

    Text {
        id: label

        anchors.left: parent.left
        anchors.leftMargin: root.iconSize + Tokens.spacing.sm
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        text: Services.Hyprland.appName
        elide: Text.ElideRight
        color: Theme.colors.m3onSurfaceVariant
        font.family: Tokens.fontFamily.sans
        font.pixelSize: Tokens.fontSize.md
    }

}
