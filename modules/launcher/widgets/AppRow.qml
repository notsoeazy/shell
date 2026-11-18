import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.components
import qs.config
import qs.theme

Item {
    id: root

    required property var app

    signal activated
    signal hovered

    implicitHeight: Tokens.launcher.rowHeight

    Rectangle {
        id: tile

        width: Tokens.launcher.iconTileSize
        height: Tokens.launcher.iconTileSize
        x: Tokens.padding.md
        anchors.verticalCenter: parent.verticalCenter
        radius: Tokens.radius.md
        color: Theme.colors.m3surfaceContainerHigh

        IconImage {
            id: appImage

            anchors.fill: parent
            anchors.margins: Tokens.padding.xxs
            source: actualSize > 0 ? Quickshell.iconPath(root.app.icon || "", true) : ""
            visible: status === Image.Ready
        }

        Icons {
            anchors.centerIn: parent
            text: "app-window"
            filled: true
            size: Tokens.iconSize.lg
            color: Theme.colors.m3onSurfaceVariant
            visible: !appImage.visible
        }
    }

    Column {
        anchors.left: tile.right
        anchors.leftMargin: Tokens.spacing.sm
        anchors.right: parent.right
        anchors.rightMargin: Tokens.padding.xxl + Tokens.padding.xxxl
        anchors.verticalCenter: parent.verticalCenter
        spacing: Tokens.spacing.xxs

        Text {
            width: parent.width
            text: root.app.name || ""
            elide: Text.ElideRight
            color: Theme.colors.m3onSurface
            font.family: Tokens.fontFamily.sans
            font.pixelSize: Tokens.fontSize.md
        }

        Text {
            width: parent.width
            text: root.app.genericName || root.app.comment || ""
            visible: text.length > 0
            elide: Text.ElideRight
            color: Theme.colors.m3onSurfaceVariant
            font.family: Tokens.fontFamily.sans
            font.pixelSize: Tokens.fontSize.sm
        }
    }

    HoverHandler {
        onHoveredChanged: {
            if (hovered)
                root.hovered();
        }
    }

    TapHandler {
        onTapped: root.activated()
    }
}
