import Quickshell
import qs.modules.bar
import qs.modules.background
import qs.showcase

ShellRoot {
    // To review a showcase, comment out components above and enable one below.
    // FontShowcase {}
    // IconShowcase {}

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
