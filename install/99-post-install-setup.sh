#!/usr/bin/env bash
source "$GROOB_DIR/install/core.sh"
BOOT_SCRIPT=$GROOB_DIR/install/post-install.sh

chmod +x "$BOOT_SCRIPT"

echo "$SUDO_USER ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/groob-post-install
chmod 440 /etc/sudoers.d/groob-post-install

sed -i "s/^end)/\thl.exec_cmd(\"$BOOT_SCRIPT\")\nend)/" "$USER_HOME/.config/hypr/autostart.lua"

print_success "Post install script set up"
print_warning "Rebooting..."

sleep 2
reboot
