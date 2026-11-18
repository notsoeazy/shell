import QtQuick
import Quickshell.Wayland
import qs.services

WlSessionLock {
    id: root

    property var clockScreen: null
    property rect clockRect: Qt.rect(0, 0, 0, 0)
    property real clockPixelSize: 0
    property bool clockVisible: false

    function captureClock(screen: var, rect: rect, pixelSize: real, visible: bool): void {
        clockScreen = screen;
        clockRect = rect;
        clockPixelSize = pixelSize;
        clockVisible = visible && rect.width > 0 && rect.height > 0;
    }

    locked: Lock.requested
    onSecureChanged: Lock.secure = secure

    LockSurface {
        clockScreen: root.clockScreen
        clockRect: root.clockRect
        clockPixelSize: root.clockPixelSize
        clockVisible: root.clockVisible
    }
}
