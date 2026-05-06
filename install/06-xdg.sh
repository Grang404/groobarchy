#!/usr/bin/env bash
source "$GROOB_DIR/install/core.sh"

[[ -z "$USER_HOME" ]] && die "could not resolve USER_HOME"

print_msg "Configuring XDG directories and MIME associations..."

mkdir -p "$USER_HOME/.cache" "$USER_HOME/.config" \
	"$USER_HOME/.local/share" "$USER_HOME/.local/state" "$USER_HOME/.local/bin"

chown -R "$SUDO_USER:$SUDO_USER" "$USER_HOME/.cache" "$USER_HOME/.config" "$USER_HOME/.local"

[[ -d /etc/xdg ]] || {
	print_warning "No /etc/xdg, creating..."
	mkdir /etc/xdg
}

cp "$GROOB_DIR/dots/xdg/user-dirs.conf" "$GROOB_DIR/dots/xdg/user-dirs.defaults" /etc/xdg/ || die "Failed to copy xdg configs"
sudo -u "$SUDO_USER" xdg-user-dirs-update || die "xdg-user-dirs-update failed"

print_success "XDG configured"
