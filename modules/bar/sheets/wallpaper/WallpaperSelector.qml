import QtQuick
import Quickshell.Widgets
import qs.components
import qs.config
import qs.modules.bar
import qs.services
import qs.theme

Item {
    id: root

    property bool active: false
    property bool interactive: false
    readonly property bool wantsKeyboard: true
    property int selectedIndex: 0
    property bool placing: true
    readonly property real thumbWidth: Tokens.wallpaper.thumbnailWidth
    readonly property real thumbHeight: thumbWidth * 9 / 16
    readonly property real stripHeight: thumbHeight * Tokens.wallpaper.selectedScale + Tokens.spacing.sm * 2
    implicitWidth: Math.min(Screen.width - 2 * Tokens.padding.xl, thumbWidth * Tokens.wallpaper.visibleItems + Tokens.wallpaper.gap * (Tokens.wallpaper.visibleItems - 1))
    implicitHeight: stripHeight + Tokens.spacing.md + Tokens.wallpaper.hintHeight + Tokens.spacing.md + Tokens.wallpaper.hintHeight

    function place(): void {
        if (active && strip.count > 0 && strip.width > 0) {
            strip.forceLayout();
            strip.positionViewAtIndex(selectedIndex, ListView.Center);
        }
    }
    function schedulePlacement(): void {
        if (!active || !placing) return;
        Qt.callLater(place);
        placementTimer.restart();
    }
    function select(index: int): void {
        if (!Wallpapers.list.length) return;
        placing = false;
        placementTimer.stop();
        selectedIndex = Math.max(0, Math.min(Wallpapers.list.length - 1, index));
        Wallpapers.preview = Wallpapers.list[selectedIndex];
    }
    function commit(): void {
        if (!Wallpapers.list.length) return;
        Wallpapers.set(Wallpapers.list[selectedIndex]);
        BarState.closeSheet();
    }
    onActiveChanged: {
        if (active) {
            placing = true;
            selectedIndex = Math.max(0, Wallpapers.list.indexOf(Wallpapers.current));
            Wallpapers.resetThumbnails();
            schedulePlacement();
        } else {
            Wallpapers.preview = "";
            Wallpapers.thumbnailQueue = [];
        }
    }
    onInteractiveChanged: {
        if (interactive) Qt.callLater(() => { if (root.interactive) strip.forceActiveFocus(); });
        else strip.focus = false;
    }
    Component.onDestruction: Wallpapers.preview = ""

    Timer {
        id: placementTimer
        interval: 100
        onTriggered: {
            root.place();
            root.placing = false;
        }
    }

    ListView {
        id: strip
        objectName: "wallpaperStrip"
        anchors.top: parent.top
        width: parent.width
        height: root.stripHeight
        orientation: ListView.Horizontal
        spacing: Tokens.wallpaper.gap
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        model: Wallpapers.list
        header: Item { width: Math.max(0, (strip.width - root.thumbWidth) / 2); height: strip.height }
        footer: Item { width: Math.max(0, (strip.width - root.thumbWidth) / 2); height: strip.height }
        currentIndex: root.selectedIndex
        highlightMoveDuration: root.placing ? 0 : Tokens.animDuration.spatialFast
        highlightMoveVelocity: -1
        preferredHighlightBegin: (width - root.thumbWidth) / 2
        preferredHighlightEnd: (width + root.thumbWidth) / 2
        highlightRangeMode: ListView.ApplyRange
        onCountChanged: {
            root.selectedIndex = Math.max(0, Wallpapers.list.indexOf(Wallpapers.current));
            root.placing = true;
            root.schedulePlacement();
        }
        onWidthChanged: root.schedulePlacement()
        Keys.onLeftPressed: root.select(root.selectedIndex - 1)
        Keys.onRightPressed: root.select(root.selectedIndex + 1)
        Keys.onReturnPressed: root.commit()
        Keys.onEnterPressed: root.commit()
        Keys.onEscapePressed: BarState.closeSheet()

        delegate: Item {
            id: cell
            required property string modelData
            required property int index
            readonly property bool selected: root.selectedIndex === index
            property real factor: selected ? Tokens.wallpaper.selectedScale : 1
            width: root.thumbWidth
            height: strip.height
            z: selected ? 1 : 0
            Component.onCompleted: Wallpapers.requestThumbnail(modelData)
            Connections {
                target: Wallpapers
                function onThumbnailsReset(): void { Wallpapers.requestThumbnail(cell.modelData); }
            }
            Behavior on factor { Anim { duration: Tokens.animDuration.spatialFast; easing.bezierCurve: Tokens.animCurve.spatialFast } }
            ClippingRectangle {
                id: thumbnail
                anchors.centerIn: parent
                width: cell.width * cell.factor
                height: root.thumbHeight * cell.factor
                radius: Tokens.radius.md
                color: Theme.colors.m3surfaceContainerHighest
                Image {
                    anchors.fill: parent
                    source: Wallpapers.thumbnails[cell.modelData] ?? ""
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    sourceSize.width: 480
                    sourceSize.height: 270
                }
                Rectangle {
                    anchors.fill: parent
                    radius: thumbnail.radius
                    color: "transparent"
                    border.width: 2
                    border.color: Theme.colors.m3primary
                    opacity: cell.selected ? 1 : 0
                    Behavior on opacity { Anim { duration: Tokens.animDuration.effectsFast; easing.bezierCurve: Tokens.animCurve.effectsFast } }
                }
                MouseArea { anchors.fill: parent; onClicked: root.select(cell.index) }
            }
        }
    }
    Text {
        anchors.centerIn: strip
        visible: Wallpapers.list.length === 0
        text: "No pictures found in " + Wallpapers.directory
        color: Theme.colors.m3onSurfaceVariant
        font.family: Tokens.fontFamily.sans
        font.pixelSize: Tokens.fontSize.sm
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideMiddle
    }
    Item {
        id: details
        anchors.top: strip.bottom
        anchors.topMargin: Tokens.spacing.md
        width: parent.width
        height: Tokens.wallpaper.hintHeight
        Text {
            anchors.left: parent.left
            anchors.leftMargin: Tokens.padding.sm
            anchors.verticalCenter: parent.verticalCenter
            width: Math.max(0, parent.width - countLabel.width - 2 * Tokens.padding.lg)
            text: Wallpapers.thumbnailError || (Wallpapers.list[root.selectedIndex] ?? "").split("/").pop()
            color: Theme.colors.m3onSurfaceVariant
            font.family: Tokens.fontFamily.sans
            font.pixelSize: Tokens.fontSize.sm
            elide: Text.ElideMiddle
        }
        Text {
            id: countLabel
            anchors.right: parent.right
            anchors.rightMargin: Tokens.padding.sm
            anchors.verticalCenter: parent.verticalCenter
            text: Wallpapers.list.length ? `${root.selectedIndex + 1} of ${Wallpapers.list.length}` : ""
            color: Theme.colors.m3onSurfaceVariant
            font.family: Tokens.fontFamily.sans
            font.pixelSize: Tokens.fontSize.sm
        }
    }
    KeyHints {
        anchors.top: details.bottom
        anchors.topMargin: Tokens.spacing.md
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: Tokens.padding.sm
        anchors.rightMargin: Tokens.padding.sm
        height: Tokens.wallpaper.hintHeight
        closeLabel: "cancel"
        hints: [{ key: "←→", text: "browse" }, { key: "↵", text: "enter" }]
    }
}
