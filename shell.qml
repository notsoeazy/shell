import QtQuick
import Quickshell
import qs.modules.bar
import qs.modules.background
import qs.showcase
import qs.services as Services

ShellRoot {
    // To review a showcase, comment out components above and enable one below.
    // FontShowcase {}
    // IconShowcase {}

    Component.onCompleted: Services.Ipc.initialize()

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
