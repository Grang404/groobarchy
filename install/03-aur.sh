#!/usr/bin/env bash

source "$GROOB_DIR/install/core.sh"

install_paru() {
	command -v paru &>/dev/null && {
		print_msg "paru already installed, skipping"
		return
	}

	print_msg "Installing paru..."

	if command -v rustc &>/dev/null; then
		print_msg "rust already installed, skipping"
	else
		sudo pacman -S --needed --noconfirm rustup || {
			die "rustup install failed"
		}
		rustup default stable
	fi

	local paru_dir="/tmp/paru"
	local sudoers_drop="/etc/sudoers.d/makepkg_tmp"

	git clone https://aur.archlinux.org/paru.git "$paru_dir" || {
		die "Failed to clone paru"
	}

	chown -R "$SUDO_USER:$SUDO_USER" "$paru_dir"

	echo "$SUDO_USER ALL=(ALL) NOPASSWD: ALL" >"$sudoers_drop"
	chmod 440 "$sudoers_drop"
	sudo -u "$SUDO_USER" bash -c "cd $paru_dir && makepkg -si --noconfirm" || {
		die "Failed to install Paru"
	}
	rm -f "$sudoers_drop" || print_warning "Failed to remove $sudoers_drop"

	print_success "paru installed"
}

install_aur_packages() {
	local file=$GROOB_DIR/install/packages/aur.pkgs

	if [[ -f "$file" ]]; then
		mapfile -t pkgs < <(
			grep -v '^\s*#' "$file" | grep -v '^\s*$' | sed 's/\s*#.*//' | tr -d ' '
		)
	else
		print_warning "$file missing!"
	fi

	print_msg "Installing AUR packages..."
	sudo -u "$SUDO_USER" paru -S --needed --noconfirm "${pkgs[@]}" || {
		die "Failed to install AUR packages"
	}

	print_success "AUR packages done"
}

install_paru
install_aur_packages
