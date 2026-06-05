#!/usr/bin/env bash

source "$GROOB_DIR/install/core.sh"
source "$GROOB_DIR/install/detect.sh"

[[ -z "$USER_HOME" ]] && die "could not resolve USER_HOME"

CONFIG="$USER_HOME/.config"

[[ -d "$DOTS" ]] || die "Dotfiles directory not found: $DOTS"

# config dirs
shopt -s nullglob
for dir in "$DOTS"/*; do
	[[ -d "$dir" ]] || continue
	[[ "$(basename "$dir")" = "hypr" ]] && continue
	link "$dir" "$CONFIG/$(basename "$dir")"
done

# hypr
mkdir -p "$CONFIG/hypr"

for f in "$DOTS/hypr"/*.conf; do link "$f" "$CONFIG/hypr/$(basename "$f")"; done
for f in "$DOTS/hypr"/*.lua; do link "$f" "$CONFIG/hypr/$(basename "$f")"; done
shopt -u nullglob

# home dotfiles
for dot in zshrc p10k.zsh zprofile zshenv; do
	link "$DOTS/$dot" "$USER_HOME/.$dot"
done

# mimelist
link "$DOTS/mimeapps.list" "$CONFIG/mimeapps.list"

mkdir -p "$USER_HOME/pictures"
[[ -n "$SUDO_USER" ]] && chown "$SUDO_USER" "$USER_HOME/pictures"
link "$GROOB_DIR/wallpapers" "$USER_HOME/pictures/wallpapers"

print_success "Dotfiles linked"
