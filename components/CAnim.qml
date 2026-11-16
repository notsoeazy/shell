import QtQuick
import qs.config

ColorAnimation {
    duration: Tokens.animDuration.effects
    easing.type: Easing.BezierSpline
    easing.bezierCurve: Tokens.animCurve.effects
}
