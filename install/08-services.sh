#!/usr/bin/env bash
source "$GROOB_DIR/install/core.sh"
[[ -z "$PROFILE" ]] && die "PROFILE is not set"

print_msg "Enabling system services..."

system_services=(
	"cronie.service"
	"fstrim.timer"
)

desktop_services=(
	"NetworkManager"
	"lm_sensors.service"
)

laptop_services=(
	"bluetooth.service"
	"tlp.service"
	"iwd.service"
)

services=("${system_services[@]}")
[[ "$PROFILE" == "laptop" ]] && services+=("${laptop_services[@]}")
[[ "$PROFILE" == "desktop" ]] && services+=("${desktop_services[@]}")

for service in "${services[@]}"; do
	if ! systemctl list-unit-files | grep -q "^$service"; then
		print_warning "$service not found, skipping"
		continue
	fi
	systemctl enable --now "$service" || {
		print_warning "Failed to enable $service"
		continue
	}
	print_success "Enabled $service"
done

print_success "Services started"
