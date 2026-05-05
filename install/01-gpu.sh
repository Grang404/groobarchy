#!/usr/bin/env bash

source "$GROOB_DIR/install/core.sh"
source "$GROOB_DIR/install/detect.sh"

GPU="${GPU:-$(detect_gpu)}"

print_msg "Installing GPU drivers ($GPU)..."

install_gpu_pkgs() {
	sudo pacman -S --needed --noconfirm "$@" || {
		print_error "GPU driver failed to install"
		exit 1
	}
}

case "$GPU" in
amd) install_gpu_pkgs vulkan-radeon lib32-vulkan-radeon mesa lib32-mesa ;;
nvidia) install_gpu_pkgs nvidia nvidia-utils lib32-nvidia-utils ;;
intel) install_gpu_pkgs mesa lib32-mesa vulkan-intel lib32-vulkan-intel ;;
*)
	print_warning "Unknown GPU, skipping"
	exit 0
	;;
esac

print_success "GPU drivers installed"
