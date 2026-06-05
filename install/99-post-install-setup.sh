#!/usr/bin/env bash
source "$GROOB_DIR/install/core.sh"
BOOT_SCRIPT=$GROOB_DIR/install/post-install.sh

chmod +x "$BOOT_SCRIPT"

echo "$SUDO_USER ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/groob-post-install
chmod 440 /etc/sudoers.d/groob-post-install

awk -v cmd="$BOOT_SCRIPT" '/^end\)/{print "\thl.exec_cmd(\""cmd"\")"}1' "$DOTS/hypr/shared/autostart.lua" > /tmp/autostart.lua && mv /tmp/autostart.lua "$DOTS/hypr/shared/autostart.lua"

print_success "Post install script set up"
print_warning "Rebooting..."

# sleep 2
# reboot
