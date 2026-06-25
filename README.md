# groobarchy

My Hyprland dotfiles. Named in protest of [omarchy](https://omarchy.org/), which I don't hate but also don't want managing my machine.

Not intended to be a general-purpose setup - this is my config, tuned for my hardware, my workflow, and my preferences. It's opinionated and makes assumptions about your system that are almost certainly wrong for yours.

That said, if you find anything useful in here feel free to take it. No attribution needed.

## What's in here

- `dots/` - the actual dotfiles (Hyprland, Waybar, Alacritty, etc.)
- `bin/` - small scripts that get linked into `~/.local/bin`
- `wallpapers/` - wallpapers
- `install/` - modular install scripts, run in order by `install.sh`

## If you do want to run the installer

Don't, probably, but if you really want to:

```bash
git clone https://github.com/Grang404/groobarchy.git ~/.local/share/groobarchy
cd ~/.local/share/groobarchy
sudo ./install.sh
```

It expects to live at `~/.local/share/groobarchy` and will move itself there if it isn't already. It detects whether you're on a laptop or desktop and skips power management stuff accordingly.

It'll also try to detect your GPU. If it gets that wrong, things may not work great.

## Things it assumes

- Arch Linux
- You are not me

That last one is the important one.

---

Anyway, hope you find something useful in here. If not, at least you got a peek at how someone else does it.
