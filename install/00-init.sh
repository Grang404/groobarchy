#!/usr/bin/env bash

source "$GROOB_DIR/install/core.sh"

print_msg "Updating system..."
sudo pacman -Syu --noconfirm
print_success "System updated"

if grep -q "^\[multilib\]" /etc/pacman.conf; then
	print_msg "Multilib already enabled, skipping"
else
	print_msg "Enabling multilib..."
	sudo sed -i '/^\#\[multilib\]/,/^\#Include = \/etc\/pacman.d\/mirrorlist/ s/^#//' /etc/pacman.conf
	sudo pacman -Sy --noconfirm
	print_success "Multilib enabled"
fi
