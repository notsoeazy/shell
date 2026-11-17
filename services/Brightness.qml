pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string device: ""
    property int maximum: 1
    property int raw: 0
    property int pending: -1
    property int desired: -1
    readonly property bool available: device !== ""
    readonly property real value: Math.max(0, Math.min(1, raw / maximum))
    readonly property string icon: value < 0.33 ? "sun-dim" : value < 0.67 ? "sun-horizon" : "sun"

    function set(value: real): void {
        if (!available || !isFinite(value))
            return;
        desired = Math.max(1, Math.min(maximum, Math.round(value * maximum)));
        pending = desired;
        writeNext();
    }
    function change(delta: real): void {
        const base = desired >= 0 ? desired / maximum : value;
        set(base + delta);
    }
    function writeNext(): void {
        if (writer.running || pending < 0)
            return;
        const next = pending;
        pending = -1;
        writer.command = ["brightnessctl", "--quiet", "--device", device, "set", String(next)];
        writer.running = true;
    }
    function refresh(): void {
        if (available)
            reader.reload();
    }

    Process {
        running: true
        command: ["brightnessctl", "--machine-readable", "--class", "backlight"]
        stdout: StdioCollector {
            onStreamFinished: {
                const fields = text.trim().split("\n")[0].split(",");
                const maxValue = Number(fields[4]);
                const current = Number(fields[2]);
                if (fields.length >= 5 && fields[0] && Number.isFinite(maxValue) && maxValue > 0 && Number.isFinite(current)) {
                    root.maximum = maxValue;
                    root.raw = current;
                    root.device = fields[0];
                }
            }
        }
    }
    Process {
        id: writer
        onExited: (code, status) => {
            if (code !== 0)
                console.warn("Brightness: unable to set backlight", code);
            if (root.pending >= 0)
                Qt.callLater(root.writeNext);
            else {
                root.desired = -1;
                root.refresh();
            }
        }
    }
    FileView {
        id: reader
        path: root.available ? `/sys/class/backlight/${root.device}/brightness` : ""
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: {
            const current = Number(text().trim());
            if (Number.isFinite(current))
                root.raw = current;
        }
    }
    Timer {
        interval: 1000
        running: root.available
        repeat: true
        onTriggered: root.refresh()
    }
}
