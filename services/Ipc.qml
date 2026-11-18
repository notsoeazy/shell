pragma Singleton
import Quickshell
import Quickshell.Io
import qs.config
import qs.modules.bar

Singleton {
    // Referenced by ShellRoot to register handlers at startup.
    function initialize(): void {
        Osd.initialize();
        Idle.initialize();
    }

    IpcHandler {
        target: "lock"
        function lock(): void {
            Lock.lock();
        }
    }

    IpcHandler {
        target: "launcher"
        function toggle(): void {
            BarState.toggleLauncher();
        }
        function open(): void {
            BarState.openLauncher();
        }
        function close(): void {
            BarState.closeSheet();
        }
    }

    IpcHandler {
        target: "bar"
        function toggleExpanded(): void {
            BarState.toggleExpanded();
        }
    }

    IpcHandler {
        target: "wallpaper"
        function toggle(): void {
            BarState.toggleWallpaper();
        }
    }
    IpcHandler {
        target: "audio"
        function volumeUp(): void {
            Audio.changeVolume(Math.max(0, Config.steps.volume));
        }
        function volumeDown(): void {
            Audio.changeVolume(-Math.max(0, Config.steps.volume));
        }
        function setVolume(value: real): void {
            Audio.setVolume(value);
        }
        function toggleMute(): void {
            Audio.toggleMute();
        }
        function toggleMicMute(): void {
            Audio.toggleMicMute();
        }
        function setMicMuted(value: bool): void {
            Audio.setMicMuted(value);
        }
    }
    IpcHandler {
        target: "brightness"
        function up(): void {
            Brightness.change(Math.max(0, Config.steps.brightness));
        }
        function down(): void {
            Brightness.change(-Math.max(0, Config.steps.brightness));
        }
        function set(value: real): void {
            Brightness.set(value);
        }
    }
    IpcHandler {
        target: "osd"
        function message(icon: string, text: string): void {
            Osd.showMessage(icon, text);
        }
        function dismiss(): void {
            Osd.dismiss();
        }
    }
}
