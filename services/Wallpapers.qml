pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.config
import qs.utils

Singleton {
    id: root

    readonly property string directory: FilePath.expandHome(Config.wallpaper.directory)
    property list<string> list: []
    property string current: ""
    property string preview: ""
    readonly property string showing: preview || current
    property string pendingSave: ""
    property bool refreshPending: false
    property var thumbnails: ({})
    property var thumbnailQueue: []
    property string thumbnailPath: ""
    property string thumbnailError: ""
    property string saveError: ""

    signal thumbnailsReset

    function requestThumbnail(path: string): void {
        if (!path || thumbnails[path] !== undefined || thumbnailPath === path || thumbnailQueue.includes(path))
            return;
        thumbnailQueue = [path, ...thumbnailQueue];
        nextThumbnail();
    }
    function nextThumbnail(): void {
        if (thumbnailer.running || thumbnailQueue.length === 0)
            return;
        thumbnailPath = thumbnailQueue[0];
        thumbnailQueue = thumbnailQueue.slice(1);
        thumbnailer.running = true;
    }
    function resetThumbnails(): void {
        thumbnails = ({});
        thumbnailQueue = [];
        thumbnailError = "";
        thumbnailsReset();
    }

    function refresh(): void {
        if (finder.running)
            refreshPending = true;
        else
            finder.running = true;
    }
    function set(path: string): void {
        if (!list.includes(path))
            return;
        current = path;
        preview = "";
        pendingSave = path;
        saveNext();
    }
    function saveNext(): void {
        if (!saver.running && pendingSave) {
            saver.command = ["python3", Quickshell.shellPath("utils/wallpapers.py"), "save", FilePath.wallpaperState, pendingSave];
            pendingSave = "";
            saver.running = true;
        }
    }
    onDirectoryChanged: refresh()

    Process {
        id: finder
        command: ["python3", Quickshell.shellPath("utils/wallpapers.py"), "scan", root.directory, FilePath.wallpaperState, FilePath.wallpaperCache]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                if (root.refreshPending)
                    return;
                try {
                    const result = JSON.parse(text);
                    const chosen = root.current || result.selected;
                    root.current = result.images.includes(chosen) ? chosen : (result.images[0] || "");
                    root.list = result.images;
                } catch (error) {
                    console.warn("Wallpapers: could not read image list:", error);
                }
            }
        }
        onExited: (code, status) => {
            if (code !== 0)
                console.warn("Wallpapers: scan failed:", code);
            if (root.refreshPending) {
                root.refreshPending = false;
                Qt.callLater(root.refresh);
            }
        }
    }
    Process {
        id: thumbnailer
        command: ["python3", Quickshell.shellPath("utils/wallpapers.py"), "thumbnail", FilePath.wallpaperCache, root.thumbnailPath]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const result = JSON.parse(text);
                    root.thumbnails = Object.assign({}, root.thumbnails, {
                        [root.thumbnailPath]: FilePath.fileUrl(result)
                    });
                } catch (error) {}
            }
        }
        onExited: (code, status) => {
            if (code !== 0) {
                root.thumbnails = Object.assign({}, root.thumbnails, {
                    [root.thumbnailPath]: ""
                });
                root.thumbnailError = "Thumbnail unavailable; ImageMagick (magick) is required.";
            }
            root.thumbnailPath = "";
            Qt.callLater(root.nextThumbnail);
        }
    }
    Process {
        id: saver
        onExited: (code, status) => {
            if (code !== 0) {
                console.warn("Wallpapers: could not save selection:", code);
                root.saveError = "Could not save wallpaper selection";
                Osd.showMessage("warning", "Could not save wallpaper selection");
            } else if (!root.pendingSave)
                root.saveError = "";
            Qt.callLater(root.saveNext);
        }
    }
}
