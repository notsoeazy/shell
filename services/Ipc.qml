pragma Singleton
import Quickshell
import Quickshell.Io
import qs.modules.bar

Singleton {
    // Referenced by ShellRoot to register handlers at startup.
    function initialize(): void {}

    IpcHandler {
        target: "launcher"
        function toggle(): void { BarState.toggleLauncher() }
        function open(): void { BarState.openLauncher() }
        function close(): void { BarState.closeSheet() }
    }

    IpcHandler {
        target: "bar"
        function toggleExpanded(): void { BarState.toggleExpanded() }
    }

    IpcHandler {
        target: "wallpaper"
        function toggle(): void { BarState.toggleWallpaper() }
    }
}
