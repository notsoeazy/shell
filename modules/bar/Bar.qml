
import Quickshell
import QtQuick

import qs.modules.bar.widgets
import qs.config
import qs.theme

PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 40

    color: Theme.colors.surface

    Clock {
        anchors.centerIn: parent
    }
}
