pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property var applications: DesktopEntries.applications.values.filter(app => !app.noDisplay)

    // Prefer an exact prefix, then substring matches; retain a stable name order.
    function search(query: string): var {
        const terms = query.trim().toLowerCase().split(/\s+/).filter(term => term.length > 0);
        return applications.map(app => {
            const name = (app.name || "").toLowerCase();
            const other = `${app.genericName || ""} ${app.comment || ""} ${(app.keywords || []).join(" ")}`.toLowerCase();
            if (!terms.every(term => name.includes(term) || other.includes(term)))
                return null;
            const score = terms.reduce((total, term) => total + (name.startsWith(term) ? 3 : name.includes(term) ? 2 : 1), 0);
            return { app: app, score: score };
        }).filter(result => result !== null)
            .sort((a, b) => b.score - a.score || a.app.name.localeCompare(b.app.name))
            .map(result => result.app);
    }
}
