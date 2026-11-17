import QtQuick
import qs.config

Item {
    id: root

    property string text: ""
    property color color: "black"
    property real size: Tokens.iconSize.md
    property bool bold: false
    property bool filled: false
    property bool animationEnabled: true
    property int animationDuration: Tokens.animDuration.effectsFast
    property string frontText: ""
    property string backText: ""
    property real blend: 0

    implicitWidth: size
    implicitHeight: size

    function updateIcon(): void {
        if (!frontText || !animationEnabled) {
            transition.stop();
            blend = 0;
            frontText = text;
            return;
        }
        if (text === backText && transition.running)
            return;
        if (transition.running) {
            transition.stop();
            if (blend >= 0.5)
                frontText = backText;
        }
        blend = 0;
        if (text === frontText)
            return;
        backText = text;
        transition.start();
    }
    onTextChanged: updateIcon()
    onAnimationEnabledChanged: {
        if (!animationEnabled) {
            transition.stop();
            frontText = text;
            blend = 0;
        }
    }

    Icons {
        anchors.fill: parent
        text: root.frontText
        color: root.color
        size: root.size
        bold: root.bold
        filled: root.filled
        animationEnabled: root.animationEnabled
        animationDuration: root.animationDuration
        opacity: 1 - root.blend
    }
    Icons {
        anchors.fill: parent
        text: root.backText
        color: root.color
        size: root.size
        bold: root.bold
        filled: root.filled
        animationEnabled: root.animationEnabled
        animationDuration: root.animationDuration
        opacity: root.blend
    }
    NumberAnimation {
        id: transition
        target: root
        property: "blend"
        from: 0
        to: 1
        duration: root.animationDuration
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Tokens.animCurve.effectsFast
        onFinished: {
            root.frontText = root.backText;
            root.blend = 0;
        }
    }
}
