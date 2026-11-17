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
    color: Theme.colors.m3surface

    Text {
        anchors.left: parent.left
        anchors.leftMargin: Tokens.spacing.md
        anchors.verticalCenter: parent.verticalCenter
        text: "Hello"
        color: Theme.colors.m3onSurface
        font.family: Tokens.fontFamily.sans
        font.pixelSize: Tokens.fontSize.md
        font.weight: Tokens.fontWeight.bold
        font.variableAxes: ({ "wght": Tokens.fontWeight.bold })
    }
}
```

Geist and Geist Mono are variable fonts; set `font.variableAxes.wght` when using a weight token to render the requested weight. Available token groups include `spacing`, `padding`, `margin`, `radius`, `fontFamily`, `fontSize`, `fontWeight`, `iconSize`, `animDuration`, and `animCurve`. Spacing, padding, and margin share the same scale.

Module-specific dimensions live in their own groups, such as `Tokens.launcher.width`, `rowHeight`, and `visibleRows`. The launcher height is derived from its contents and spacing.

Use Phosphor icons by name:

```qml
Icons {
    text: "microphone"
    size: Tokens.iconSize.md
    color: Theme.colors.m3onSurface
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

## Bar

Set `Config.bar.notchMode` in `config/Config.qml` to `true` for the attached notch or `false` for a floating bar. `screenGap` controls the floating gap. These values are currently edited in QML.

Set `Config.bar.idleEnabled` to `false` to keep the default bar visible. `pulseOn` selects the events that briefly show it, while `pulseDuration` and `pulseStartupDelay` control timing in milliseconds.

The distro logo comes from `/etc/os-release`; set `Config.bar.logo` to an icon-theme name or file path to override it, or set `showLogo` to `false` to hide it.

The bar uses live Hyprland workspaces and focused-window information, PipeWire audio, networking, and UPower battery status. Workspace dots can be clicked to change workspaces. `BarController.qml` keeps `BarContent.qml` mounted while `SheetController.qml` loads and transitions the launcher.

Click the clock or distro logo to open the application launcher, or run `qs -p . ipc call launcher toggle`. Type to search, use Up/Down and Enter to select an application, and press Escape to clear the search or close the launcher. The reference shell's actions, clipboard, and symbol modes are not yet available.

Hyprland integrations belong in `services/Hyprland.qml`. Import `qs.services as Services` and use `Services.Hyprland` to distinguish it from Quickshell's Hyprland API.

## Run

```sh
qs -p .
```

To review a showcase, comment out `Bar {}` in `shell.qml` and uncomment either `FontShowcase {}` or `IconShowcase {}`, then run `qs -p .`.

## Tasks
- [ ] Border and Exclusivezone
- [ ] Wallpaper - implement the wallpaper in modules/background/ and its selector sheet
- [ ] OSD - implement volume, brightness, and system messages (ex. mic muted/on, nightlight on/off) and expose IPC or function call to make customizable messages
- [ ] Lockscreen - implement a lockscreen with pam.d
- [ ] Control Panel - implement control panel and panel sheets/views (think of another name) for wifi, bluetooth, nightlight, volume, etc.
- [ ] Add media -  add media section in extended bar and implement media related controls and expose IPC
- [ ] Notifications - add notifications
- [ ] Configurations - prepare the configurations and think of what can be configured and write to .config/
- [ ] Settings panel - create a settings panel wih tabs.
- [ ] Configure hyprland bindings and personalize styles.
