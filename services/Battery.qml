pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    readonly property UPowerDevice device: UPower.displayDevice
    readonly property bool available: (device?.ready ?? false) && device.isLaptopBattery
    readonly property real level: available ? device.percentage : 0
    readonly property bool pluggedIn: available && !UPower.onBattery
    readonly property bool low: available && UPower.onBattery && level <= 0.2
    readonly property bool charging: available && (device.state === UPowerDeviceState.Charging || device.state === UPowerDeviceState.PendingCharge)
}
