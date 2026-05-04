#!/usr/bin/env bash

source "$GROOB_DIR/install/core.sh"

install_paru() {
	command -v paru &>/dev/null && {
		print_msg "paru already installed, skipping"
		return
	}

	print_msg "Installing paru..."

	sudo pacman -S --needed --noconfirm rust

	local paru_dir="/tmp/paru"
	local sudoers_drop="/etc/sudoers.d/makepkg_tmp"

	git clone https://aur.archlinux.org/paru.git "$paru_dir"
	chown -R "$SUDO_USER:$SUDO_USER" "$paru_dir"

	echo "$SUDO_USER ALL=(ALL) NOPASSWD: ALL" >"$sudoers_drop"
	chmod 440 "$sudoers_drop"
	sudo -u "$SUDO_USER" bash -c "cd $paru_dir && makepkg -si --noconfirm"
	rm -f "$sudoers_drop"

	print_success "paru installed"
}

install_aur_packages() {
	local file="$GROOB_DIR/install/packages/aur.pkgs"
	[[ -f "$file" ]] || die "Missing: $file"

	mapfile -t pkgs < <(
		grep -v '^\s*#' "$file" | grep -v '^\s*$' | sed 's/\s*#.*//' | tr -d ' '
	)

	print_msg "Installing AUR packages..."
	sudo -u "$SUDO_USER" paru -S --needed --noconfirm "${pkgs[@]}"
	print_success "AUR packages done"
}

install_paru
install_aur_packages
