# Shell

A Quickshell configuration built with QML.

## Structure

```text
shell.qml             Shell entry point
assets/               Bundled fonts
components/           Reusable UI components and animations
config/               Shared tokens and configuration
modules/              Shell features and their local widgets
services/             Shared data and system integrations
theme/                Semantic colors
utils/                Shared helpers
showcase/             Standalone component and font previews
```

## Where to add files

- Put reusable controls in `components/`; keep feature-specific widgets under their module, for example `modules/bar/widgets/`.
- Put system access and shared state in `services/`, and compose complete features under `modules/`.
- Add shared dimensions, typography, and motion values to `config/Tokens.qml`; put semantic colors in `theme/Theme.qml`.
- Keep bundled assets with their licenses in `assets/`, and shared non-UI helpers in `utils/`.
- Add visual preview windows to `showcase/`. Enable a preview from `shell.qml` when needed.

## QML examples

Import the directories you need:

```qml
import QtQuick
import qs.config
import qs.theme
import qs.components
```

Use tokens and semantic colors:

```qml
Rectangle {
    width: 240
    height: 64
    radius: Tokens.radius.md
    color: Theme.colors.surface

    Text {
        anchors.left: parent.left
        anchors.leftMargin: Tokens.spacing.md
        anchors.verticalCenter: parent.verticalCenter
        text: "Hello"
        color: Theme.colors.onSurface
        font.family: Tokens.fontFamily.sans
        font.pixelSize: Tokens.fontSize.md
        font.weight: Tokens.fontWeight.bold
        font.variableAxes: ({ "wght": Tokens.fontWeight.bold })
    }
}
```

Geist and Geist Mono are variable fonts; set `font.variableAxes.wght` when using a weight token to render the requested weight. Available token groups include `spacing`, `radius`, `fontFamily`, `fontSize`, `fontWeight`, `iconSize`, `animDuration`, and `animCurve`.

Use Phosphor icons by name:

```qml
Icons {
    text: "microphone"
    size: Tokens.iconSize.md
    color: Theme.colors.onSurface
    bold: false
    filled: true
}
```

`filled` crossfades between styles. Use `animationEnabled` and `animationDuration` to control the transition.

Use the default effects animation, or select another duration and curve:

```qml
Behavior on opacity { Anim {} }
Behavior on color { CAnim {} }

Behavior on x {
    Anim {
        duration: Tokens.animDuration.spatialFast
        easing.bezierCurve: Tokens.animCurve.spatialFast
    }
}
```

`Anim` animates numbers and `CAnim` animates colors. Both default to the `effects` tokens; use effects curves for colors.

## Run

```sh
qs -p .
```

To review a showcase, comment out `Bar {}` in `shell.qml` and uncomment either `FontShowcase {}` or `IconShowcase {}`, then run `qs -p .`. The main shell currently has QML loading errors in `Clock.qml` and `Theme.qml`.
