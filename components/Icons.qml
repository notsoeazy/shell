import QtQuick
import qs.config
import "../utils/PhosphorCodes.js" as Phosphor

Item {
    id: root

    property string text: ""
    property color color: "black"
    property real size: Tokens.iconSize.md
    property bool bold: false
    property bool filled: false
    property int animationDuration: Tokens.animDuration.effectsFast
    property bool animationEnabled: true
    readonly property string glyph: Phosphor.glyph(text)
    property real fillAmount: filled ? 1 : 0

    implicitWidth: size
    implicitHeight: size

    Glyph {
        font.family: root.bold ? Tokens.fontFamily.iconBold : Tokens.fontFamily.icon
        opacity: 1 - root.fillAmount
    }

    Glyph {
        font.family: Tokens.fontFamily.iconFill
        opacity: root.fillAmount
    }

    Behavior on fillAmount {
        enabled: root.animationEnabled

        Anim {
            duration: root.animationDuration
            easing.bezierCurve: Tokens.animCurve.effectsFast
        }

    }

    component Glyph: Text {
        anchors.fill: parent
        text: root.glyph
        color: root.color
        font.pixelSize: Math.max(1, root.size)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        textFormat: Text.PlainText
        renderType: Text.NativeRendering
    }

}
