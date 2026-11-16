
pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property Colors colors: Colors {}

    component Colors: QtObject {
        // Primary
        readonly property color primary: "#AAC7FF"
        readonly property color surfaceTint: "#AAC7FF"
        readonly property color onPrimary: "#0A305F"
        readonly property color primaryContainer: "#284777"
        readonly property color onPrimaryContainer: "#D6E3FF"

        // Secondary
        readonly property color secondary: "#BEC6DC"
        readonly property color onSecondary: "#283141"
        readonly property color secondaryContainer: "#3E4759"
        readonly property color onSecondaryContainer: "#DAE2F9"

        // Tertiary
        readonly property color tertiary: "#DDBCE0"
        readonly property color onTertiary: "#3F2844"
        readonly property color tertiaryContainer: "#573E5C"
        readonly property color onTertiaryContainer: "#FAD8FD"

        // Error
        readonly property color error: "#FFB4AB"
        readonly property color onError: "#690005"
        readonly property color errorContainer: "#93000A"
        readonly property color onErrorContainer: "#FFDAD6"

        // Background & Surface
        readonly property color background: "#111318"
        readonly property color onBackground: "#E2E2E9"
        readonly property color surface: "#111318"
        readonly property color onSurface: "#E2E2E9"
        readonly property color surfaceVariant: "#44474E"
        readonly property color onSurfaceVariant: "#C4C6D0"

        // Outline
        readonly property color outline: "#8E9099"
        readonly property color outlineVariant: "#44474E"

        // Shadow & Scrim
        readonly property color shadow: "#000000"
        readonly property color scrim: "#000000"

        // Inverse Colors
        readonly property color inverseSurface: "#E2E2E9"
        readonly property color inverseOnSurface: "#2E3036"
        readonly property color inversePrimary: "#415F91"

        // Primary Fixed
        readonly property color primaryFixed: "#D6E3FF"
        readonly property color onPrimaryFixed: "#001B3E"
        readonly property color primaryFixedDim: "#AAC7FF"
        readonly property color onPrimaryFixedVariant: "#284777"

        // Secondary Fixed
        readonly property color secondaryFixed: "#DAE2F9"
        readonly property color onSecondaryFixed: "#131C2B"
        readonly property color secondaryFixedDim: "#BEC6DC"
        readonly property color onSecondaryFixedVariant: "#3E4759"

        // Tertiary Fixed
        readonly property color tertiaryFixed: "#FAD8FD"
        readonly property color onTertiaryFixed: "#28132E"
        readonly property color tertiaryFixedDim: "#DDBCE0"
        readonly property color onTertiaryFixedVariant: "#573E5C"

        // Surface Containers
        readonly property color surfaceDim: "#111318"
        readonly property color surfaceBright: "#37393E"
        readonly property color surfaceContainerLowest: "#0C0E13"
        readonly property color surfaceContainerLow: "#191C20"
        readonly property color surfaceContainer: "#1D2024"
        readonly property color surfaceContainerHigh: "#282A2F"
        readonly property color surfaceContainerHighest: "#33353A"
    }
}
