pragma Singleton

import QtQuick
import Quickshell
import qs.config

Singleton {
    id: root

    property bool expanded: false
    property bool expandedByIpc: false
    property bool pointerInside: false
    property bool hoverBlocked: false
    property string activeSheet: ""
    readonly property bool wallpaperOpen: activeSheet === "wallpaper"
    readonly property bool launcherOpen: activeSheet === "launcher"
    property bool pulsing: false
    property string sheetHeaderMode: "idle"

    readonly property string barMode: expanded || expandedByIpc ? "expanded" : pulsing || !Config.bar.idleEnabled ? "default" : "idle"
    readonly property string mode: activeSheet !== "" ? "sheet" : barMode
    readonly property string headerMode: activeSheet !== "" ? sheetHeaderMode : barMode
    readonly property bool showSides: headerMode !== "idle"
    readonly property bool showDetails: headerMode === "expanded"

    function openLauncher(): void {
        enterTimer.stop();
        if (activeSheet === "")
            sheetHeaderMode = barMode;
        activeSheet = "launcher";
    }

    function toggleWallpaper(): void {
        if (wallpaperOpen) closeSheet();
        else {
            enterTimer.stop();
            if (activeSheet === "") sheetHeaderMode = barMode;
            activeSheet = "wallpaper";
        }
    }

    function closeSheet(): void {
        if (activeSheet === "") return;
        activeSheet = "";
        expanded = false;
        hoverBlocked = pointerInside;
        enterTimer.stop();
    }

    function toggleExpanded(): void {
        const shouldExpand = activeSheet !== "" || barMode !== "expanded";
        if (activeSheet !== "") closeSheet();
        enterTimer.stop();
        exitTimer.stop();
        expanded = false;
        expandedByIpc = shouldExpand;
        hoverBlocked = !shouldExpand && pointerInside;
    }

    function toggleLauncher(): void {
        if (launcherOpen) closeSheet();
        else openLauncher();
    }

    function pointerEntered(): void {
        pointerInside = true;
        exitTimer.stop();
        if (!hoverBlocked && activeSheet === "") enterTimer.restart();
    }

    function pointerExited(): void {
        pointerInside = false;
        hoverBlocked = false;
        enterTimer.stop();
        exitTimer.restart();
    }

    function pulse(): void {
        if (activeSheet !== "") return;
        pulsing = true;
        pulseTimer.restart();
    }

    Timer { id: enterTimer; interval: 80; onTriggered: root.expanded = true }
    Timer { id: exitTimer; interval: 300; onTriggered: root.expanded = false }
    Timer { id: pulseTimer; interval: Math.max(0, Config.bar.pulseDuration); onTriggered: root.pulsing = false }
}
