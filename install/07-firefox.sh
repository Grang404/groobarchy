#!/usr/bin/env bash
source "$GROOB_DIR/install/core.sh"
[[ -z "$USER_HOME" ]] && die "could not resolve USER_HOME"

print_msg "Configuring Firefox..."

firefox_profile=$(find "$USER_HOME/.mozilla/firefox" -maxdepth 1 -type d -name "*.default-release" 2>/dev/null | head -n1)

if [[ -z "$firefox_profile" ]]; then
	print_msg "No profile found, creating one..."
	sudo -u "$SUDO_USER" timeout 5 firefox --headless >/dev/null 2>&1 || true
	sleep 2
	firefox_profile=$(find "$USER_HOME/.config/mozilla/firefox" -maxdepth 1 -type d -name "*.default-release" 2>/dev/null | head -n1)
	[[ -z "$firefox_profile" ]] && die "Failed to create Firefox profile"
fi

cp "$GROOB_DIR/dots/firefox/user.js" "$firefox_profile/user.js" || die "Failed to copy user.js"
chown "$SUDO_USER:$SUDO_USER" "$firefox_profile/user.js"

print_success "Firefox configured"
