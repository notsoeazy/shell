pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    readonly property var fields: parse(osRelease.text())
    readonly property string logo: fields.LOGO ?? ""
    readonly property string distroId: fields.ID ?? ""

    function parse(text: string): var {
        const result = {};
        for (const line of text.split("\n")) {
            const match = line.match(/^([A-Z_]+)=(.*)$/);
            if (match)
                result[match[1]] = match[2].replace(/^["']|["']$/g, "");
        }
        return result;
    }

    FileView { id: osRelease; path: "/etc/os-release"; blockLoading: true }
}
