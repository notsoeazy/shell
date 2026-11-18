pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Networking

Singleton {
    readonly property var devices: Networking.devices.values
    readonly property var wifi: devices.find(d => d.type === DeviceType.Wifi) ?? null
    readonly property var wired: devices.find(d => d.type === DeviceType.Wired) ?? null
    readonly property bool wifiConnected: devices.some(d => d.type === DeviceType.Wifi && d.connected)
    readonly property bool wiredConnected: devices.some(d => d.type === DeviceType.Wired && d.connected)
    readonly property bool connected: wifiConnected || wiredConnected
    readonly property bool wifiEnabled: Networking.wifiEnabled
}
