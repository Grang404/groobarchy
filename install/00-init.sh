#!/usr/bin/env bash

source "$GROOB_DIR/install/core.sh"

print_msg "Updating system..."
sudo pacman -Syu --noconfirm || {
	die "System update failed"
}

print_success "System updated"

if grep -q "^\[multilib\]" /etc/pacman.conf; then
	print_msg "Multilib already enabled, skipping"
else
	print_msg "Enabling multilib..."

	multilib_pattern='\|^#\[multilib\]|,\|^#Include = /etc/pacman.d/mirrorlist| s/^#//'
	sudo sed -i "$multilib_pattern" /etc/pacman.conf || {
		die "Failed to write to /etc/pacman.conf"
	}

	sudo pacman -Sy --noconfirm || {
		die "Failed to enable multilib"
	}
	print_success "Multilib enabled"
fi
