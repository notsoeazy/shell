pragma Singleton
import Quickshell
import QtQuick

Singleton {
    readonly property Spacing spacing: Spacing {}
    readonly property Spacing padding: spacing
    readonly property Spacing margin: spacing
    readonly property Radius radius: Radius {}
    readonly property FontFamilies fontFamily: FontFamilies {}
    readonly property FontSizes fontSize: FontSizes {}
    readonly property FontWeights fontWeight: FontWeights {}
    readonly property IconSizes iconSize: IconSizes {}
    readonly property AnimationDurations animDuration: AnimationDurations {}
    readonly property AnimationCurves animCurve: AnimationCurves {}
    
    readonly property LauncherTokens launcher: LauncherTokens {}
    readonly property WallpaperTokens wallpaper: WallpaperTokens {}
    readonly property OsdTokens osd: OsdTokens {}
    readonly property LockTokens lock: LockTokens {}

    FontLoader {
        id: geistSans

        source: "../assets/Geist/Geist-Variable.ttf"
    }

    FontLoader {
        id: geistMono

        source: "../assets/Geist/GeistMono-Variable.ttf"
    }

    FontLoader {
        id: phosphorRegular

        source: "../assets/Phosphor/Phosphor.ttf"
    }

    FontLoader {
        id: phosphorBold

        source: "../assets/Phosphor/Phosphor-Bold.ttf"
    }

    FontLoader {
        id: phosphorFill

        source: "../assets/Phosphor/Phosphor-Fill.ttf"
    }

    component AnimationDurations: QtObject {
        readonly property int spatialFast: 350
        readonly property int spatial: 500
        readonly property int spatialSlow: 650
        readonly property int effectsQuick: 100
        readonly property int effectsFast: 150
        readonly property int effects: 200
        readonly property int effectsSlow: 300
        readonly property int linear: 1000
    }

    component AnimationCurves: QtObject {
        readonly property var spatialFast: [0.42, 1.67, 0.21, 0.9, 1, 1]
        readonly property var spatial: [0.38, 1.21, 0.22, 1, 1, 1]
        readonly property var spatialSlow: [0.39, 1.29, 0.35, 0.98, 1, 1]
        readonly property var effectsFast: [0.31, 0.94, 0.34, 1, 1, 1]
        readonly property var effects: [0.34, 0.8, 0.34, 1, 1, 1]
        readonly property var effectsSlow: [0.34, 0.88, 0.34, 1, 1, 1]
        readonly property var linear: [0, 0, 1, 1, 1, 1]
    }

    component FontFamilies: QtObject {
        readonly property string sans: geistSans.name
        readonly property string mono: geistMono.name
        readonly property string icon: phosphorRegular.name
        readonly property string iconBold: phosphorBold.name
        readonly property string iconFill: phosphorFill.name
    }

    component FontSizes: QtObject {
        readonly property int xxs: 10
        readonly property int xs: 11
        readonly property int sm: 12
        readonly property int md: 14
        readonly property int lg: 16
        readonly property int xl: 20
        readonly property int xxl: 24
        readonly property int xxxl: 32
    }

    component IconSizes: QtObject {
        readonly property int xs: 12
        readonly property int sm: 14
        readonly property int md: 16
        readonly property int lg: 20
        readonly property int xl: 24
        readonly property int xxl: 32
    }

    component FontWeights: QtObject {
        readonly property int thin: Font.Thin
        readonly property int extraLight: Font.ExtraLight
        readonly property int light: Font.Light
        readonly property int regular: Font.Normal
        readonly property int medium: Font.Medium
        readonly property int semiBold: Font.DemiBold
        readonly property int bold: Font.Bold
        readonly property int extraBold: Font.ExtraBold
        readonly property int black: Font.Black
    }

    component Spacing: QtObject {
        readonly property int xxs: 2
        readonly property int xs: 4
        readonly property int sm: 8
        readonly property int md: 12
        readonly property int lg: 16
        readonly property int xl: 20
        readonly property int xxl: 24
        readonly property int xxxl: 32
    }

    component Radius: QtObject {
        readonly property int sm: 4
        readonly property int md: 8
        readonly property int lg: 12
        readonly property int xl: 16
        readonly property int full: 9999
    }

    // Module Specific Tokens
    component LauncherTokens: QtObject {
        readonly property int width: 512
        readonly property int searchHeight: 44
        readonly property int rowHeight: 48
        readonly property int visibleRows: 6
        readonly property int iconTileSize: 32
        readonly property int hintHeight: 16
        readonly property int emptyHeight: 72
    }
    
    component WallpaperTokens: QtObject {
        readonly property int thumbnailWidth: 192
        readonly property int gap: 32
        readonly property int visibleItems: 5
        readonly property real selectedScale: 1.25
        readonly property int hintHeight: 24
    }

    component OsdTokens: QtObject {
        readonly property int width: 224
        readonly property int height: 28
        readonly property int maxMessageWidth: 480
    }

    component LockTokens: QtObject {
        readonly property int clockSize: 96
        readonly property int fieldWidth: 288
        readonly property int fieldHeight: 48
        readonly property real clockCenter: 0.3
        readonly property real fieldCenter: 0.72
    }
}
