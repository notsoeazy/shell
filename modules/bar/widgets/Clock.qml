import QtQuick
import qs.services
import qs.config
import qs.theme

Item {
    id: root

    property real detailProgress: 0
    property real detailOpacity: 0

    implicitWidth: Math.max(time.width * time.scale, date.implicitWidth * detailProgress)
    implicitHeight: time.height * time.scale + (date.implicitHeight + Tokens.spacing.xs) * detailProgress

    Text {
        id: time

        x: (root.width - width) / 2
        y: 0
        transformOrigin: Item.Top
        scale: 1 + 0.35 * root.detailProgress
        text: Time.format("hh:mm AP")
        color: Theme.colors.m3onSurface
        font.family: Tokens.fontFamily.sans
        font.pixelSize: Tokens.fontSize.md
        font.weight: Tokens.fontWeight.semiBold
        font.variableAxes: ({
                "wght": Tokens.fontWeight.semiBold
            })
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        id: date

        x: (root.width - width) / 2
        y: time.height * time.scale + Tokens.spacing.xs * root.detailProgress
        text: Time.format("ddd, MMM d")
        color: Theme.colors.m3onSurfaceVariant
        font.family: Tokens.fontFamily.sans
        font.pixelSize: Tokens.fontSize.md
        opacity: root.detailOpacity
    }
}
