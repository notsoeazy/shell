pragma Singleton
import Quickshell
import Quickshell.Io
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
            Audio.changeVolume(0.05);
        }
        function volumeDown(): void {
            Audio.changeVolume(-0.05);
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
            Brightness.change(0.05);
        }
        function down(): void {
            Brightness.change(-0.05);
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
