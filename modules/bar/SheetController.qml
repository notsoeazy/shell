import QtQuick
import qs.modules.bar
import qs.modules.launcher
import qs.modules.wallpaper

// The registry and loader for visual sheets. BarController owns its fade.
Item {
    id: root
    property string sheetName: ""
    property bool interactive: false
    property bool loaded: false
    readonly property bool ready: loader.status === Loader.Ready
    readonly property real contentWidth: ready && loader.item ? loader.item.implicitWidth : 0
    readonly property real contentHeight: ready && loader.item ? loader.item.implicitHeight : 0
    readonly property bool wantsKeyboard: ready && loader.item ? (loader.item.wantsKeyboard ?? false) : false

    function prepare(name: string): void {
        if (name === sheetName && loaded)
            return;
        loaded = false;
        sheetName = name;
        loaded = componentFor(name) !== null;
        if (!loaded && name !== "")
            console.warn("Unknown bar sheet:", name);
    }
    function release(): void {
        loaded = false;
        sheetName = "";
    }
    function componentFor(name: string): var {
        switch (name) {
        case "launcher":
            return launcherComponent;
        case "wallpaper":
            return wallpaperComponent;
        default:
            return null;
        }
    }

    Component {
        id: launcherComponent
        Launcher {
            active: true
            interactive: root.interactive && BarState.launcherOpen
        }
    }
    Component {
        id: wallpaperComponent
        WallpaperSelector {
            active: BarState.wallpaperOpen
            interactive: root.interactive && BarState.wallpaperOpen
        }
    }
    Loader {
        id: loader
        active: root.loaded
        asynchronous: true
        sourceComponent: root.componentFor(root.sheetName)
        width: root.width
        height: root.contentHeight
    }
}
