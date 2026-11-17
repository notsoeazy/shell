import QtQuick
import qs.components
import qs.config
import qs.modules.bar
import qs.modules.bar.widgets

Item {
    id: root

    property real detailProgress: BarState.showDetails ? 1 : 0
    readonly property real centerGap: Tokens.spacing.xl
    readonly property real sideWidth: Math.max(0, (width - centerGroup.width) / 2 - centerGap - Tokens.padding.xl)

    // Follow the animated bar height directly; animating y toward a target
    // based on that same moving height would continually restart the motion.
    function sideRowY(rowHeight: real) : real {
        const centered = (height - rowHeight) / 2;
        const bottom = height - rowHeight - Tokens.padding.md;
        return centered + detailProgress * (bottom - centered);
    }

    // The clock owns both time and date and stays mounted in every state.
    Clock {
        id: centerGroup

        x: (root.width - width) / 2
        y: (root.height - height) / 2
        detailProgress: root.detailProgress

        TapHandler {
            onTapped: BarState.toggleLauncher()
        }

    }

    ActiveWindow {
        x: Tokens.padding.xl
        y: BarState.showDetails ? Math.max(Tokens.padding.sm, centerGroup.y) : Tokens.padding.md
        width: Math.min(implicitWidth, root.sideWidth)
        height: implicitHeight
        opacity: root.detailProgress
    }

    NotificationSummary {
        width: Math.min(implicitWidth, root.sideWidth)
        height: implicitHeight
        x: root.width - width - Tokens.padding.xl
        y: BarState.showDetails ? Math.max(Tokens.padding.sm, centerGroup.y) : Tokens.padding.md
        opacity: root.detailProgress
    }

    Row {
        id: leading

        x: Tokens.padding.xl
        width: Math.min(implicitWidth, root.sideWidth)
        clip: true
        y: root.sideRowY(height)
        spacing: Tokens.spacing.xs
        opacity: BarState.showSides ? 1 : 0
        enabled: BarState.showSides

        DistroLogo {
            anchors.verticalCenter: parent.verticalCenter
            width: implicitWidth
            height: implicitHeight
            onActivated: BarState.toggleLauncher()
        }

        Workspaces {
            anchors.verticalCenter: parent.verticalCenter
            width: implicitWidth
            height: implicitHeight
        }

        Behavior on opacity {
            Anim {
            }

        }

    }

    StatusIcons {
        x: root.width - width - Tokens.padding.xl
        width: Math.min(implicitWidth, root.sideWidth)
        clip: true
        y: root.sideRowY(height)
        opacity: BarState.showSides ? 1 : 0

        Behavior on opacity {
            Anim {
            }

        }

    }

    Behavior on detailProgress {
        Anim {
            duration: Tokens.animDuration.effects
            easing.bezierCurve: Tokens.animCurve.effects
        }

    }

}
