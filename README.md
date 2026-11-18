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
- The launcher and wallpaper selector live in `modules/launcher/` and `modules/wallpaper/`; `modules/bar/SheetController.qml` loads them into the bar.
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

`filled` crossfades between styles. Use `animationEnabled` and `animationDuration` to control the transition. Use `AnimatedIcon` for a crossfade when an icon name changes; it accepts the same styling and animation options.

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

## Documentation

Feature and configuration notes are kept locally in `documentation/` which will be used in creating a wiki in the future. This directory is not committed.

## IPC

IPC commands are registered centrally in `services/Ipc.qml`. For example, use `qs -p . ipc call launcher toggle` `qs -p . ipc call wallpaper toggle`, or `qs -p . ipc call bar toggleExpanded`.

The OSD lives in `modules/osd/` and exposes `audio`, `brightness`, and `osd` IPC targets. For example, `qs -p . ipc call osd message info "Example message"` shows a custom message. Volume and microphone state come from PipeWire; backlight control requires `brightnessctl` and a supported device. `Config.osd` controls which categories are shown.

`Config.steps.volume` and `Config.steps.brightness` set the fraction changed by each IPC up/down command or OSD wheel notch. Both default to `0.05` (5%); zero disables relative changes. Brightness changes use at least one hardware step.

The wallpaper selector refreshes its image list when opened. Thumbnails unused for 30 days are removed from the shell's wallpaper cache during a scan. If saving a selection fails, the selector shows an error and the message OSD reports it when enabled.

## Lockscreen

The shell locks after 300 seconds of inactivity by default. Set `Config.idle.lockAfter` in `config/Config.qml` to a different number of seconds, or `0` to disable idle locking. Run `qs -p . ipc call lock lock` to lock manually. Unlocking uses the system PAM `login` authentication stack; no project-specific PAM file is installed. The lock uses Wayland session-lock surfaces, and the compositor may remain locked if the shell exits while locked.

## Run

```sh
qs -p .
```

To review a showcase, comment out `Bar {}` in `shell.qml` and uncomment either `FontShowcase {}` or `IconShowcase {}`, then run `qs -p .`.

## Tasks
- [x] Border and Exclusivezone
- [x] Wallpaper - implement the wallpaper in modules/background/ and its selector sheet
- [x] OSD - implement volume, brightness, and system messages (ex. mic muted/on, nightlight on/off) and expose IPC or function call to make customizable messages
- [x] Lockscreen - implement a lockscreen with pam.d
- [ ] Control Panel - implement control panel and panel sheets/views (think of another name) for wifi, bluetooth, nightlight, volume, etc.
- [ ] Add media -  add media section in extended bar and implement media related controls and expose IPC
- [ ] Notifications - add notifications
- [ ] Configurations - prepare the configurations and think of what can be configured and write to .config/
- [ ] Settings panel - create a settings panel wih tabs.
- [ ] Configure hyprland bindings and personalize styles.
