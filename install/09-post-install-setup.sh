#!/usr/bin/env bash
source "$GROOB_DIR/install/core.sh"
BOOT_SCRIPT=$GROOB_DIR/install/post-install.sh

chmod +x "$BOOT_SCRIPT"

print_warning "DEBUG: SUDO_USER=$SUDO_USER"
print_warning "DEBUG: MAKING SUDO FILE"

echo "$SUDO_USER ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/groob-post-install
chmod 440 /etc/sudoers.d/groob-boot-setup
print_warning "DEBUG: SUDO FILE SHOULD BE REAL"
ls /etc/sudoers.d/

echo "exec-once = $BOOT_SCRIPT" >>"$USER_HOME/.config/hypr/hyprland.conf"

print_success "Post install script set up"
print_warning "Rebooting..."

sleep 2
reboot
