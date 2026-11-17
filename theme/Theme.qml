pragma Singleton
import Quickshell
import QtQuick

Singleton {
    readonly property Colors
    colors: Colors {
    }

    component Colors: QtObject {
        // Primary
        readonly property color m3primary: "#AAC7FF"
        readonly property color m3surfaceTint: "#AAC7FF"
        readonly property color m3onPrimary: "#0A305F"
        readonly property color m3primaryContainer: "#284777"
        readonly property color m3onPrimaryContainer: "#D6E3FF"
        // Secondary
        readonly property color m3secondary: "#BEC6DC"
        readonly property color m3onSecondary: "#283141"
        readonly property color m3secondaryContainer: "#3E4759"
        readonly property color m3onSecondaryContainer: "#DAE2F9"
        // Tertiary
        readonly property color m3tertiary: "#DDBCE0"
        readonly property color m3onTertiary: "#3F2844"
        readonly property color m3tertiaryContainer: "#573E5C"
        readonly property color m3onTertiaryContainer: "#FAD8FD"
        // Error
        readonly property color m3error: "#FFB4AB"
        readonly property color m3onError: "#690005"
        readonly property color m3errorContainer: "#93000A"
        readonly property color m3onErrorContainer: "#FFDAD6"
        // Background & Surface
        readonly property color m3background: "#111318"
        readonly property color m3onBackground: "#E2E2E9"
        readonly property color m3surface: "#111318"
        readonly property color m3onSurface: "#E2E2E9"
        readonly property color m3surfaceVariant: "#44474E"
        readonly property color m3onSurfaceVariant: "#C4C6D0"
        // Outline
        readonly property color m3outline: "#8E9099"
        readonly property color m3outlineVariant: "#44474E"
        // Shadow & Scrim
        readonly property color m3shadow: "#000000"
        readonly property color m3scrim: "#000000"
        // Inverse Colors
        readonly property color m3inverseSurface: "#E2E2E9"
        readonly property color m3inverseOnSurface: "#2E3036"
        readonly property color m3inversePrimary: "#415F91"
        // Primary Fixed
        readonly property color m3primaryFixed: "#D6E3FF"
        readonly property color m3onPrimaryFixed: "#001B3E"
        readonly property color m3primaryFixedDim: "#AAC7FF"
        readonly property color m3onPrimaryFixedVariant: "#284777"
        // Secondary Fixed
        readonly property color m3secondaryFixed: "#DAE2F9"
        readonly property color m3onSecondaryFixed: "#131C2B"
        readonly property color m3secondaryFixedDim: "#BEC6DC"
        readonly property color m3onSecondaryFixedVariant: "#3E4759"
        // Tertiary Fixed
        readonly property color m3tertiaryFixed: "#FAD8FD"
        readonly property color m3onTertiaryFixed: "#28132E"
        readonly property color m3tertiaryFixedDim: "#DDBCE0"
        readonly property color m3onTertiaryFixedVariant: "#573E5C"
        // Surface Containers
        readonly property color m3surfaceDim: "#111318"
        readonly property color m3surfaceBright: "#37393E"
        readonly property color m3surfaceContainerLowest: "#0C0E13"
        readonly property color m3surfaceContainerLow: "#191C20"
        readonly property color m3surfaceContainer: "#1D2024"
        readonly property color m3surfaceContainerHigh: "#282A2F"
        readonly property color m3surfaceContainerHighest: "#33353A"
    }

}
