#!/usr/bin/env bash
source "$GROOB_DIR/install/core.sh"

BOOT_SCRIPT="$GROOB_DIR/install/post-install.sh"

[[ -f "$BOOT_SCRIPT" ]] || die "Boot script not found: $BOOT_SCRIPT"
[[ -n "$DOTS" ]] || die "DOTS is not set"

AUTOSTART="$DOTS/hypr/shared/autostart.lua"
[[ -f "$AUTOSTART" ]] || die "autostart.lua not found: $AUTOSTART"

chmod +x "$BOOT_SCRIPT" || die "Failed to chmod boot script"

echo "$SUDO_USER ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/groob-post-install || die "Failed to write sudoers"
chmod 440 /etc/sudoers.d/groob-post-install || die "Failed to chmod sudoers"

if ! awk -v cmd="$BOOT_SCRIPT" '/^end\)/{print "\thl.exec_cmd(\""cmd"\")"}1' "$AUTOSTART" >/tmp/autostart.lua; then
	die "Failed to patch autostart.lua"
fi
mv /tmp/autostart.lua "$AUTOSTART" || die "Failed to move autostart.lua"

print_success "Post install script set up"
print_warning "Rebooting..."

sleep 2
reboot
