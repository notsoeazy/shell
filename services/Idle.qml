pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.config

Singleton {
    function initialize(): void {
    }
    IdleMonitor {
        enabled: Config.idle.lockAfter > 0
        timeout: Math.max(0, Config.idle.lockAfter)
        respectInhibitors: true
        onIsIdleChanged: if (isIdle)
            Lock.lock()
    }
}
