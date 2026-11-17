import QtQuick
import Quickshell
import qs.config
import qs.services as Services

// Translate selected service changes into brief default-bar pulses.
Scope {
    id: root
    property bool ready: false

    function fire(kind: string): void {
        if (ready && Config.bar.pulseOn.includes(kind) && BarState.activeSheet === "")
            BarState.pulse();
    }

    Timer {
        interval: Math.max(0, Config.bar.pulseStartupDelay)
        running: true
        onTriggered: root.ready = true
    }
    Connections {
        target: Services.Hyprland
        function onActiveChanged(): void { root.fire("workspace") }
    }
    Connections {
        target: Services.Audio
        function onVolumeChanged(): void { if (Services.Audio.sinkReady) root.fire("volume") }
        function onMutedChanged(): void { if (Services.Audio.sinkReady) root.fire("volume") }
        function onMicMutedChanged(): void { if (Services.Audio.sourceReady) root.fire("microphone") }
    }
    Connections {
        target: Services.Network
        function onConnectedChanged(): void { root.fire("network") }
    }
    Connections {
        target: Services.Battery
        function onPluggedInChanged(): void { if (Services.Battery.available) root.fire("battery") }
        function onLowChanged(): void { if (Services.Battery.available) root.fire("battery") }
    }
}
