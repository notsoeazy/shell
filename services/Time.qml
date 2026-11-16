pragma Singleton

import Quickshell
import QtQuick

Singleton { 

    function format(pattern: string): string {
        return Qt.formatDateTime(clock.date, pattern);
    }

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }
}