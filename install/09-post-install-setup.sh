#!/usr/bin/env bash
source "$GROOB_DIR/install/core.sh"
BOOT_SCRIPT=$GROOB_DIR/install/post-install.sh

chmod +x "$BOOT_SCRIPT"

echo "$SUDO_USER ALL=(ALL) NOPASSWD: $BOOT_SCRIPT" >/etc/sudoers.d/groob-boot-setup
chmod 440 /etc/sudoers.d/groob-boot-setup

echo "exec-once = sudo $BOOT_SCRIPT" >>"$USER_HOME/.config/hypr/hyprland.conf"

print_success "Post install script set up"
print_warning "Rebooting..."

sleep 2
reboot
