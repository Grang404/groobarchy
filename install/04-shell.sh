#!/usr/bin/env bash

source "$GROOB_DIR/install/core.sh"

PLUGINS_DIR="$HOME/.local/share/groob/dots/zsh/plugins"
THEMES_DIR="$HOME/.local/share/groob/dots/zsh/themes"

mkdir -p "$PLUGINS_DIR" "$THEMES_DIR"

clone_if_missing() {
	local url="$1"
	local dest="$2"
	local name="$(basename "$dest")"

	if [[ -d "$dest" ]]; then
		print_msg "$name already exists, skipping"
		return
	fi

	git clone --depth=1 "$url" "$dest"
	print_success "$name installed"
}

clone_if_missing https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting "$PLUGINS_DIR/zsh-syntax-highlighting"
clone_if_missing https://github.com/romkatv/powerlevel10k "$THEMES_DIR/powerlevel10k"

chsh -s /usr/bin/zsh "$USER"
print_success "ZSH configured"
