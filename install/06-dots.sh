#!/usr/bin/env bash

source "$GROOB_DIR/install/core.sh"
source "$GROOB_DIR/install/detect.sh"

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
for dir in "$DOTS"/*; do
	[ -d "$dir" ] || continue
	[ "$(basename "$dir")" = "hypr" ] && continue
	link "$dir" "$CONFIG/$(basename "$dir")"
done

# hypr
mkdir -p "$CONFIG/hypr"
for f in "$DOTS/hypr"/*.conf; do link "$f" "$CONFIG/hypr/$(basename "$f")"; done

# home dotfiles
for dot in zshrc p10k.zsh zprofile zshenv; do
	link "$DOTS/$dot" "$HOME/.$dot"
done

print_success "Dotfiles linked"
