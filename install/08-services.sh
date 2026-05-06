#!/usr/bin/env bash
source "$GROOB_DIR/install/core.sh"
[[ -z "$PROFILE" ]] && die "PROFILE is not set"

print_msg "enabling system services..."

system_services=(
	"cronie.service"
	# "lm_sensors.service"
	"fstrim.timer"
)

laptop_services=(
	"bluetooth.service"
	"tlp.service"
	"iwd.service"
)

services=("${system_services[@]}")
[[ "$PROFILE" == "laptop" ]] && services+=("${laptop_services[@]}")

for service in "${services[@]}"; do
	if ! systemctl list-unit-files | grep -q "^$service"; then
		print_warning "$service not found, skipping"
		continue
	fi
	systemctl enable --now "$service" || {
		print_warning "failed to enable $service"
		continue
	}
	print_success "enabled $service"
done

print_success "services done"
