pragma Singleton
import QtQuick
import Quickshell

Singleton {
    readonly property string home: Quickshell.env("HOME")
    readonly property string configDir: xdgDirectory("XDG_CONFIG_HOME", ".config") + "/testshell"
    readonly property string stateDir: xdgDirectory("XDG_STATE_HOME", ".local/state") + "/testshell"
    readonly property string cacheDir: xdgDirectory("XDG_CACHE_HOME", ".cache") + "/testshell"
    readonly property string wallpaperState: stateDir + "/wallpaper.json"
    readonly property string wallpaperCache: cacheDir + "/wallpapers"

    function xdgDirectory(variable: string, fallback: string) : string {
        const value = Quickshell.env(variable);
        return value && value.startsWith("/") ? value.replace(/\/+$/, "") : home + "/" + fallback;
    }

    function expandHome(path: string) : string {
        if (path === "~")
            return home;

        return path.startsWith("~/") ? home + path.slice(1) : path;
    }

    function fileUrl(path: string) : string {
        return "file://" + path.split("/").map((part) => {
            return encodeURIComponent(part);
        }).join("/");
    }

}
