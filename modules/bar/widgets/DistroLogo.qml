import QtQuick
import QtQuick.Effects
import Quickshell
import qs.config
import qs.services
import qs.theme

Item {
    id: root

    readonly property string name: Config.bar.logo || Distro.logo
    readonly property string source: name.startsWith("/") ? "file://" + name : name.startsWith("~/") ? "file://" + Quickshell.env("HOME") + name.slice(1) : name ? Quickshell.iconPath(name, true) : ""
    readonly property bool available: Config.bar.showLogo && source !== "" && logo.status !== Image.Error

    signal activated()

    visible: available
    implicitWidth: available ? Tokens.iconSize.lg : 0
    implicitHeight: available ? Tokens.iconSize.lg : 0

    Image {
        id: logo

        anchors.fill: parent
        source: root.source
        sourceSize: Qt.size(Tokens.iconSize.lg * Screen.devicePixelRatio, Tokens.iconSize.lg * Screen.devicePixelRatio)
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        visible: false
    }

    MultiEffect {
        anchors.fill: logo
        source: logo
        colorization: 1
        colorizationColor: Theme.colors.m3onSurface
    }

    TapHandler {
        onTapped: root.activated()
    }

}
