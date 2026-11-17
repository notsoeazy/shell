pragma Singleton
import QtQuick
import Quickshell

Singleton {
    readonly property BarConfig
    bar: BarConfig {
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

}
