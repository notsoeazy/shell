import QtQuick
import QtQuick.Layouts
import qs.config
import qs.theme

RowLayout {
    id: root

    property var hints: []
    property string closeLabel: "close"

    spacing: Tokens.spacing.lg

    Hint {
        key: "esc"
        label: root.closeLabel
    }

    Item {
        Layout.fillWidth: true
    }

    Repeater {
        model: root.hints

        Hint {
            required property var modelData

            key: modelData.key ?? ""
            symbol: modelData.symbol ?? ""
            label: modelData.text ?? ""
        }

    }

    component Hint: Row {
        property string key: ""
        property string symbol: ""
        property string label: ""

        spacing: Tokens.spacing.xs

        Icons {
            visible: parent.symbol !== ""
            text: parent.symbol
            size: Tokens.iconSize.sm
            color: Theme.colors.m3onSurface
        }

        Text {
            visible: parent.key !== ""
            text: parent.key
            color: Theme.colors.m3onSurface
            font.family: Tokens.fontFamily.mono
            font.pixelSize: Tokens.fontSize.sm
        }

        Text {
            text: parent.label
            color: Theme.colors.m3onSurfaceVariant
            font.family: Tokens.fontFamily.sans
            font.pixelSize: Tokens.fontSize.sm
        }

    }

}
