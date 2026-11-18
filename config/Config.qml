pragma Singleton
import QtQuick
import Quickshell

Singleton {
    readonly property WallpaperConfig wallpaper: WallpaperConfig {}
    readonly property BarConfig bar: BarConfig {}
    readonly property BorderConfig border: BorderConfig {}
    readonly property OsdConfig osd: OsdConfig {}
    readonly property IdleConfig idle: IdleConfig {}

    component WallpaperConfig: QtObject {
        property bool enabled: true
        property string directory: "~/Pictures/Wallpapers"
    }

    component BorderConfig: QtObject {
        property bool enabled: true
        property int thickness: 10
        property int radius: 20
        property int spacing: 5
    }

    component BarConfig: QtObject {
        // true: attached notch; false: floating rounded bar.
        property bool notchMode: true
        property int screenGap: 10
        property int barHeight: 44
        property int idleWidth: 150
        property int workspaceCount: 5
        property bool idleEnabled: false
        property int pulseDuration: 3000
        property int pulseStartupDelay: 2000
        property list<string> pulseOn: ["workspace", "volume", "microphone", "network", "battery"]
        property bool showLogo: true
        // Empty uses the distro icon from /etc/os-release.
        property string logo: ""
    }

    component OsdConfig: QtObject {
        property bool enabled: true
        property bool volume: true
        property bool brightness: true
        property bool microphone: true
        property bool messages: true
        property int levelTimeout: 1500
        property int messageTimeout: 2500
    }

    component IdleConfig: QtObject {
        property int lockAfter: 300
    }
}
