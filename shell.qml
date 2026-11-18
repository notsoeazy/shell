import QtQuick
import Quickshell
import qs.modules.bar
import qs.modules.background
import qs.modules.lock
import qs.showcase
import qs.services as Services

ShellRoot {
    // To review a showcase, comment out components above and enable one below.
    // FontShowcase {}
    // IconShowcase {}

    Component.onCompleted: Services.Ipc.initialize()

    Connections {
        target: Services.Lock
        function onAboutToLock(): void {
            lockScreen.captureClock(bar.screen, bar.clockSceneRect(), bar.clockPixelSize, bar.clockVisible);
        }
    }

    LockScreen {
        id: lockScreen
    }

    Background {
        revealOrigin: bar.wallpaperOrigin
    }

    Border {
        id: border
    }

    ExclusiveZone {
        borderThickness: border.effectiveThickness
    }

    Bar {
        id: bar

        borderThickness: border.effectiveThickness
    }
}
