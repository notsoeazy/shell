import QtQuick
import qs.config

NumberAnimation {
    duration: Tokens.animDuration.effects
    easing.type: Easing.BezierSpline
    easing.bezierCurve: Tokens.animCurve.effects
}
