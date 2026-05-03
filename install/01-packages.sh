#!/usr/bin/env bash

source "$GROOB_DIR/install/core.sh"
source "$GROOB_DIR/install/detect.sh"

PROFILE="${PROFILE:-$(detect_platform)}"
PKG_DIR="$GROOB_DIR/install/packages"

install_group() {
	local group="$1"
	local file="$PKG_DIR/$group.pkgs"

	[[ -f "$file" ]] || {
		print_warning "Missing: $file, skipping"
		return
	}

	mapfile -t pkgs < <(
		grep -v '^\s*#' "$file" | grep -v '^\s*$' | sed 's/\s*#.*//' | tr -d ' '
	)

	print_msg "Installing $group packages..."
	sudo pacman -S --needed --noconfirm "${pkgs[@]}"
	print_success "$group done"
}

groups=(core apps fonts utils)
[[ "$PROFILE" == "laptop" && -f "$PKG_DIR/laptop.pkgs" ]] && groups+=(laptop)

for group in "${groups[@]}"; do
	install_group "$group"
done

user_pkgs="$HOME/.config/groob/packages.pkgs"
if [[ -f "$user_pkgs" ]]; then
	print_msg "Installing user packages..."
	mapfile -t pkgs < <(
		grep -v '^\s*#' "$user_pkgs" | grep -v '^\s*$' | sed 's/\s*#.*//' | tr -d ' '
	)
	sudo pacman -S --needed --noconfirm "${pkgs[@]}"
	print_success "User packages done"
fi
