pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root
    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource
    readonly property bool sinkReady: sink?.ready ?? false
    readonly property bool sourceReady: source?.ready ?? false
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property bool micMuted: source?.audio?.muted ?? false
    readonly property string volumeIcon: muted ? "speaker-slash" : volume <= 0 ? "speaker-none" : volume < 0.5 ? "speaker-low" : "speaker-high"

    function setVolume(value: real): void {
        if (sinkReady && sink.audio && isFinite(value))
            sink.audio.volume = Math.max(0, Math.min(1, value));
    }
    function changeVolume(delta: real): void {
        setVolume(volume + delta);
    }
    function toggleMute(): void {
        if (sinkReady && sink.audio)
            sink.audio.muted = !sink.audio.muted;
    }
    function toggleMicMute(): void {
        if (sourceReady && source.audio)
            source.audio.muted = !source.audio.muted;
    }
    function setMicMuted(value: bool): void {
        if (sourceReady && source.audio)
            source.audio.muted = value;
    }

    PwObjectTracker {
        objects: [root.sink, root.source]
    }
}
