import QtQuick
import qs.components
import qs.config
import qs.services
import qs.theme

Row {
    spacing: Tokens.spacing.sm

    Icons {
        visible: Audio.sourceReady
        text: Audio.micMuted ? "microphone-slash" : "microphone"
        filled: true
        size: Tokens.iconSize.lg
        color: Audio.micMuted ? Theme.colors.m3error : Theme.colors.m3onSurface
    }

    Icons {
        visible: Audio.sinkReady
        text: Audio.muted ? "speaker-slash" : "speaker-high"
        filled: true
        size: Tokens.iconSize.lg
        color: Theme.colors.m3onSurface
    }

    Icons {
        text: Network.wiredConnected ? "plugs-connected" : Network.wifiConnected ? "wifi-high" : "wifi-slash"
        filled: false
        bold: true
        size: Tokens.iconSize.lg
        color: Network.wifiConnected || Network.wiredConnected ? Theme.colors.m3onSurface : Theme.colors.m3outline
    }

    Icons {
        visible: Battery.available
        text: Battery.charging ? "battery-charging" : Battery.level > 0.75 ? "battery-full" : Battery.level > 0.5 ? "battery-high" : Battery.level > 0.25 ? "battery-medium" : Battery.level > 0.1 ? "battery-low" : "battery-empty"
        filled: true
        size: Tokens.iconSize.lg
        color: Battery.level <= 0.2 && !Battery.charging ? Theme.colors.m3error : Theme.colors.m3onSurface
    }

}
