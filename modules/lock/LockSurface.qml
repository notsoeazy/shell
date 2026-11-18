import QtQuick
import Quickshell.Wayland
import qs.theme

WlSessionLockSurface {
    id: root

    property var clockScreen: null
    property rect clockRect: Qt.rect(0, 0, 0, 0)
    property real clockPixelSize: 0
    property bool clockVisible: false

    color: Theme.colors.m3background
    LockContent {
        anchors.fill: parent
        travels: root.clockVisible && root.screen !== null && root.screen === root.clockScreen
        screenReady: root.screen !== null
        startRect: root.clockRect
        startPixelSize: root.clockPixelSize
    }
}
