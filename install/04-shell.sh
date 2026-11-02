#!/usr/bin/env bash

source "$GROOB_DIR/install/core.sh"

PLUGINS_DIR="$GROOB_DIR/dots/zsh/plugins"
THEMES_DIR="$GROOB_DIR/dots/zsh/themes"

mkdir -p "$PLUGINS_DIR" "$THEMES_DIR"

clone_if_missing() {
	local url=$1
	local dest=$2
	local name
	name=$(basename "$dest")

	if [[ -d "$dest" ]]; then
		print_msg "$name already exists, skipping"
		return
	fi

	if git clone --depth=1 "$url" "$dest"; then
		print_success "$name installed"
	else
		print_warning "Failed to clone: $url"
	fi
}

clone_if_missing https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting "$PLUGINS_DIR/zsh-syntax-highlighting"
clone_if_missing https://github.com/romkatv/powerlevel10k "$THEMES_DIR/powerlevel10k"

if chsh -s /usr/bin/zsh "$SUDO_USER"; then
	print_success "zsh configured"
else
	print_warning "Changing shell to zsh for $SUDO_USER failed! Do it manually"
fi
