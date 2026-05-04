#!/usr/bin/env bash

source "$GROOB_DIR/install/core.sh"
source "$GROOB_DIR/install/detect.sh"

GPU="${GPU:-$(detect_gpu)}"

print_msg "Installing GPU drivers ($GPU)..."

case "$GPU" in
amd)
	sudo pacman -S --needed --noconfirm vulkan-radeon lib32-vulkan-radeon mesa lib32-mesa
	;;
nvidia)
	sudo pacman -S --needed --noconfirm nvidia nvidia-utils lib32-nvidia-utils
	;;
intel)
	sudo pacman -S --needed --noconfirm mesa lib32-mesa vulkan-intel lib32-vulkan-intel
	;;
*)
	print_warning "Unknown GPU, skipping driver install"
	exit 0
	;;
esac

print_success "GPU drivers installed"
