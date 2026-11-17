import QtQuick
import QtQuick.Controls
import qs.config
import qs.theme

TextField {
    id: root

    signal moveSelection(int direction)
    signal escapeRequested()

    implicitHeight: 44
    leftPadding: Tokens.padding.xl + Tokens.iconSize.md + Tokens.spacing.xs
    rightPadding: Tokens.padding.md
    color: Theme.colors.m3onSurface
    placeholderTextColor: Theme.colors.m3onSurfaceVariant
    font.family: Tokens.fontFamily.sans
    font.pixelSize: Tokens.fontSize.md
    selectByMouse: true
    placeholderText: "Search"
    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Up || (event.modifiers & Qt.ControlModifier && (event.key === Qt.Key_K || event.key === Qt.Key_P))) {
            root.moveSelection(-1);
            event.accepted = true;
        } else if (event.key === Qt.Key_Down || (event.modifiers & Qt.ControlModifier && (event.key === Qt.Key_J || event.key === Qt.Key_N))) {
            root.moveSelection(1);
            event.accepted = true;
        } else if (event.key === Qt.Key_Escape) {
            root.escapeRequested();
            event.accepted = true;
        }
    }

    Icons {
        x: Tokens.padding.md
        anchors.verticalCenter: parent.verticalCenter
        text: "magnifying-glass"
        size: Tokens.iconSize.md
        color: Theme.colors.m3onSurfaceVariant
    }

    background: Rectangle {
        radius: height / 2
        color: "transparent"
        border.width: 1
        border.color: root.activeFocus ? Theme.colors.m3primary : Theme.colors.m3outlineVariant
    }

}
