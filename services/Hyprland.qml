pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland as QsHyprland

Singleton {
    readonly property int active: QsHyprland.Hyprland.focusedWorkspace?.id ?? 1
    readonly property var occupied: QsHyprland.Hyprland.workspaces.values.filter(w => w.id > 0).map(w => w.id)
    readonly property var activeWindow: QsHyprland.Hyprland.activeToplevel ?? QsHyprland.Hyprland.toplevels.values.find(t => t.wayland?.activated) ?? null
    readonly property string windowTitle: activeWindow?.title || "Desktop"
    readonly property string appId: activeWindow?.wayland?.appId ?? activeWindow?.lastIpcObject.class ?? ""
    readonly property string initialClass: activeWindow?.lastIpcObject.initialClass ?? ""
    readonly property var appEntry: findEntry(appId, initialClass)
    readonly property string appName: activeWindow ? (appEntry?.name || appId || windowTitle) : "Desktop"
    readonly property string appIcon: appEntry?.icon ?? ""

    function findEntry(appClass: string, initial: string): var {
        if (DesktopEntries.applications.values.length === 0)
            return null;
        return (appClass ? DesktopEntries.heuristicLookup(appClass) : null)
            ?? (initial ? DesktopEntries.heuristicLookup(initial) : null) ?? null;
    }

    function focus(id: int): void {
        if (QsHyprland.Hyprland.usingLua)
            QsHyprland.Hyprland.dispatch(`hl.dsp.focus({ workspace = ${id} })`);
        else
            QsHyprland.Hyprland.dispatch(`workspace ${id}`);
    }
}
