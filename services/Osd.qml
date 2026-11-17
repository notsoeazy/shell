pragma Singleton
import QtQuick
import Quickshell
import qs.config

Singleton {
    id: root

    property string kind: ""
    property string source: ""
    property string requestedIcon: ""
    readonly property string icon: kind === "level" && source === "volume" ? Audio.volumeIcon : kind === "level" && source === "brightness" ? Brightness.icon : requestedIcon
    property string message: ""
    property real value: 0
    property bool armed: false
    property bool active: false
    property bool held: false
    property bool awaitingPresentation: false
    readonly property bool adjustable: kind === "level" && (source === "volume" && Audio.sinkReady || source === "brightness" && Brightness.available)

    function showLevel(source: string, icon: string, value: real): void {
        if (!Config.osd.enabled || (source === "volume" && !Config.osd.volume) || (source === "brightness" && !Config.osd.brightness))
            return;
        root.source = source;
        root.requestedIcon = icon;
        root.value = Math.max(0, Math.min(1, value));
        root.message = "";
        root.kind = "level";
        root.active = true;
        hide.interval = Math.max(1, Config.osd.levelTimeout);
        restartTimeout();
    }
    function announce(category: string, icon: string, message: string): void {
        if (!Config.osd.enabled || (category === "microphone" ? !Config.osd.microphone : !Config.osd.messages) || !message)
            return;
        root.source = category;
        root.requestedIcon = icon || "info";
        root.message = message;
        root.kind = "message";
        root.active = true;
        hide.interval = Math.max(1, Config.osd.messageTimeout);
        restartTimeout();
    }
    function restartTimeout(): void {
        if (active && !held && !awaitingPresentation)
            hide.restart();
        else
            hide.stop();
    }
    function adjust(value: real): void {
        if (!adjustable || !isFinite(value))
            return;
        const target = Math.max(0, Math.min(1, value));
        if (source === "volume") {
            Audio.setVolume(target);
            if (Audio.muted)
                Audio.toggleMute();
        } else if (source === "brightness")
            Brightness.set(target);
        restartTimeout();
    }
    function adjustBy(delta: real): void {
        if (!adjustable || !isFinite(delta))
            return;
        const base = source === "brightness" && Brightness.desired >= 0 ? Brightness.desired / Brightness.maximum : source === "volume" ? Audio.volume : Brightness.value;
        adjust(base + delta);
    }
    onHeldChanged: restartTimeout()
    onAwaitingPresentationChanged: restartTimeout()
    function showMessage(icon: string, message: string): void {
        announce("message", icon, message);
    }
    function dismiss(): void {
        hide.stop();
        active = false;
    }
    function initialize(): void {
    }

    Timer {
        id: hide
        onTriggered: root.active = false
    }
    Timer {
        running: true
        interval: 2000
        onTriggered: root.armed = true
    }
    Connections {
        target: Audio
        function onVolumeChanged(): void {
            if (root.armed && Audio.sinkReady)
                root.showLevel("volume", Audio.volumeIcon, Audio.muted ? 0 : Audio.volume);
        }
        function onMutedChanged(): void {
            if (root.armed && Audio.sinkReady)
                root.showLevel("volume", Audio.volumeIcon, Audio.muted ? 0 : Audio.volume);
        }
        function onMicMutedChanged(): void {
            if (root.armed && Audio.sourceReady)
                root.announce("microphone", Audio.micMuted ? "microphone-slash" : "microphone", Audio.micMuted ? "Microphone muted" : "Microphone on");
        }
    }
    Connections {
        target: Brightness
        function onValueChanged(): void {
            if (root.armed && Brightness.available)
                root.showLevel("brightness", Brightness.icon, Brightness.value);
        }
    }
}
