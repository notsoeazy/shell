import Quickshell
import qs.modules.bar
import qs.modules.background
import qs.showcase

ShellRoot {
    // To review a showcase, comment out components above and enable one below.
    // FontShowcase {}
    // IconShowcase {}

    Border {
        id: border
    }

    ExclusiveZone {
        borderThickness: border.effectiveThickness
    }

    Bar {
        borderThickness: border.effectiveThickness
    }

}
