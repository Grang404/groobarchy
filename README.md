# groobarchy

My Hyprland dotfiles. Named in protest of [omarchy](https://omarchy.org/), which I don't hate but also don't want managing my machine.

Not intended to be general-purpose - this is my config, tuned for my hardware, my workflow, and my preferences. If you find anything useful, take it. No attribution needed.

## Contents

- `dots/` - dotfiles (Hyprland, Waybar, Alacritty, etc.)
- `bin/` - scripts linked into `~/.local/bin`
- `wallpapers/` - default wallpapers
- `install/` - modular install scripts, run in order by `install.sh`

## Installing

Don't, probably. But if you really want to:

```bash
git clone https://github.com/Grang404/groobarchy.git ~/.local/share/groobarchy
cd ~/.local/share/groobarchy
sudo ./install.sh
```

Expects to live at `$HOME/.local/share/groobarchy` and will move itself there if it isn't already. Detects laptop vs desktop and skips power management accordingly. Also attempts GPU detection - if it gets that wrong, things may not work.

## Usage

### Basic Keybinds


| Keybind | Action |
|---|---|
| `Shift + X` | Searchable list of all keybinds |
| `Super + R` | App launcher |
| `Super + W` | Window picker |
| `Super + I` | Wallpaper picker |
| `Super + Alt + I` | Random wallpaper |


groobarchy is set up so you can layer your own config on top without touching managed files.

### Hyprland

Create `$HOME/.config/hypr/user.lua` - it will be sourced automatically at the end of the Hyprland config.

```lua
-- Disable animations
hl.config({
    animations = {
        enabled = false,
    },
})

-- Change browser
hl.unbind("SUPER + B")
hl.bind("SUPER + B", hl.dsp.exec_cmd("chromium"))
```

### Environment

Add personal environment variables to `$HOME/.config/groobarchy/env`. This file is sourced automatically.

The following are exported by default:

| Variable | Value | Description |
|---|---|---|
| `$GROOB_DIR` | `$HOME/.local/share/groobarchy` | Root install directory |
| `$DOTS` | `$GROOB_DIR/dots` | Dotfiles directory |
| `$GROOB_ZSH` | `$DOTS/zsh` | Zsh config |
| `$GROOB_HYPR` | `$DOTS/hypr` | Hyprland config |

### Wallpapers

groobarchy ships with its own wallpapers in `$GROOB_DIR/wallpapers`. To add your own without touching that directory, set `CUSTOM_WALLPAPER` in `$HOME/.config/groobarchy/env`:

```plaintext
CUSTOM_WALLPAPER=/path/to/your/wallpapers
```

Both directories will appear in the wallpaper picker.

## Assumptions

- Arch Linux
- You are not me

That last one is the important one.
