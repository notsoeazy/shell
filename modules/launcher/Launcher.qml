import QtQuick
import qs.components
import qs.config
import qs.modules.bar
import qs.modules.launcher.widgets
import qs.services
import qs.theme

Item {
    id: root

    property bool active: false
    property bool interactive: false
    readonly property bool wantsKeyboard: true
    readonly property var results: active ? Apps.search(search.text) : []
    readonly property int visibleResultCount: Math.min(results.length, Tokens.launcher.visibleRows)
    implicitWidth: Tokens.launcher.width
    // Report the target height immediately. BarContainer and resultArea each
    // animate toward their own targets, so the footer follows the bar edge.
    implicitHeight: search.implicitHeight + Tokens.spacing.sm + resultArea.implicitHeight + Tokens.spacing.md + Tokens.launcher.hintHeight

    function moveSelection(direction: int): void {
        if (results.length === 0)
            return;
        list.currentIndex = Math.max(0, Math.min(results.length - 1, list.currentIndex + direction));
    }

    function activate(index: int): void {
        if (index < 0 || index >= results.length)
            return;
        const app = results[index];
        BarState.closeSheet();
        app.execute();
    }

    onActiveChanged: {
        if (active) {
            search.text = "";
            list.currentIndex = 0;
        }
    }

    onInteractiveChanged: {
        if (interactive)
            Qt.callLater(() => {
                if (root.interactive)
                    search.forceActiveFocus();
            });
        else
            search.focus = false;
    }

    SearchField {
        id: search
        implicitHeight: Tokens.launcher.searchHeight
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        placeholderText: "Search apps"
        onTextChanged: list.currentIndex = 0
        onAccepted: root.activate(list.currentIndex)
        onMoveSelection: direction => root.moveSelection(direction)
        onEscapeRequested: {
            if (text.length > 0)
                text = "";
            else
                BarState.closeSheet();
        }
    }

    Item {
        id: resultArea
        anchors.top: search.bottom
        anchors.topMargin: Tokens.spacing.sm
        anchors.left: parent.left
        anchors.right: parent.right
        implicitHeight: root.visibleResultCount > 0 ? root.visibleResultCount * Tokens.launcher.rowHeight + (root.visibleResultCount - 1) * Tokens.spacing.xxs : Tokens.launcher.emptyHeight
        height: implicitHeight

        Behavior on height {
            Anim {
                duration: Tokens.animDuration.spatial
                easing.bezierCurve: Tokens.animCurve.spatial
            }
        }

        ListView {
            id: list
            anchors.fill: parent
            visible: count > 0
            clip: true
            spacing: Tokens.spacing.xxs
            model: root.results
            currentIndex: count > 0 ? 0 : -1
            boundsBehavior: Flickable.StopAtBounds
            highlightMoveDuration: Tokens.animDuration.effects
            highlightMoveVelocity: -1
            highlight: Rectangle {
                width: list.width
                height: Tokens.launcher.rowHeight
                radius: Tokens.radius.lg
                color: Qt.alpha(Theme.colors.m3primary, 0.24)

                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: Tokens.padding.md
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Enter"
                    color: Theme.colors.m3onSurfaceVariant
                    font.family: Tokens.fontFamily.sans
                    font.pixelSize: Tokens.fontSize.sm
                }
            }
            delegate: AppRow {
                required property var modelData
                required property int index
                width: list.width
                app: modelData
                onHovered: list.currentIndex = index
                onActivated: root.activate(index)
            }
        }

        Column {
            anchors.centerIn: parent
            visible: list.count === 0
            spacing: Tokens.spacing.xs

            Icons {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "magnifying-glass"
                size: Tokens.iconSize.lg
                color: Theme.colors.m3onSurfaceVariant
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "No apps found"
                color: Theme.colors.m3onSurfaceVariant
                font.family: Tokens.fontFamily.sans
                font.pixelSize: Tokens.fontSize.sm
            }
        }
    }

    KeyHints {
        anchors.top: resultArea.bottom
        anchors.topMargin: Tokens.spacing.md
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: Tokens.padding.sm
        anchors.rightMargin: Tokens.padding.sm
        height: Tokens.launcher.hintHeight
        hints: [
            {
                key: "↑↓",
                text: "navigate"
            },
            {
                key: "↵",
                text: "enter"
            }
        ]
    }
}
