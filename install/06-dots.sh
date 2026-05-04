#!/usr/bin/env bash

source "$GROOB_DIR/install/core.sh"
source "$GROOB_DIR/install/detect.sh"

PROFILE="${PROFILE:-$(detect_platform)}"
DOTS="$GROOB_DIR/dots"
CONFIG="$HOME/.config"

[[ -d "$DOTS" ]] || die "dots directory not found: $DOTS"

link() {
	local src="$1" tgt="$2"
	[[ -e "$src" ]] || return
	[[ -e "$tgt" ]] && rm -rf "$tgt"
	ln -sf "$src" "$tgt"
	print_msg "Linked $(basename "$src") → $tgt"
}

# config dirs
for dir in waybar nvim ghostty rofi eza fastfetch btop gtk-2.0 gtk-3.0 gtk-4.0; do
	link "$DOTS/$dir" "$CONFIG/$dir"
done

# hypr
mkdir -p "$CONFIG/hypr"
for f in "$DOTS/hypr"/*.conf; do link "$f" "$CONFIG/hypr/$(basename "$f")"; done
for f in "$DOTS/hypr/shared"/*; do link "$f" "$CONFIG/hypr/$(basename "$f")"; done
for f in "$DOTS/hypr/$PROFILE"/*; do link "$f" "$CONFIG/hypr/$(basename "$f")"; done
print_mess
link "$DOTS/hypr/scripts" "$CONFIG/hypr/scripts"

# home dotfiles
for dot in zshrc p10k.zsh zprofile zshenv; do
	link "$DOTS/$dot" "$HOME/.$dot"
done

print_success "Dotfiles linked"
