#!/usr/bin/env bash

source "$GROOB_DIR/install/core.sh"

CONF_DIR="$USER_HOME/.config/pipewire/pipewire.conf.d"
CONF_FILE="$CONF_DIR/99-input-denoising.conf"

PLUGIN="/usr/lib/ladspa/librnnoise_ladspa.so"

[[ -f "$PLUGIN" ]] || {
	print_error "librnnoise_ladspa.so not found at $PLUGIN, is noise-suppression-for-voice installed? 👁️"
	exit 1
}

print_msg "Setting up PipeWire RNNoise filter..."

mkdir -p "$CONF_DIR"
chown "$SUDO_USER":"$SUDO_USER" "$CONF_DIR"

cat >"$CONF_FILE" <<'EOF'
context.modules = [
{   name = libpipewire-module-filter-chain
    args = {
        node.description = "Noise Canceling source"
        media.name       = "Noise Canceling source"
        filter.graph = {
            nodes = [
                {
                    type   = ladspa
                    name   = rnnoise
                    plugin = /usr/lib/ladspa/librnnoise_ladspa.so
                    label  = noise_suppressor_mono
                    control = {
                        "VAD Threshold (%)"          = 98.0
                        "VAD Grace Period (ms)"       = 200
                        "Retroactive VAD Grace (ms)"  = 0
                    }
                }
            ]
        }
        capture.props = {
            node.name    = "capture.rnnoise_source"
            node.passive = true
            audio.rate   = 48000
        }
        playback.props = {
            node.name   = "rnnoise_source"
            media.class = Audio/Source
            audio.rate  = 48000
        }
    }
}
]
EOF

chown "$SUDO_USER":"$SUDO_USER" "$CONF_FILE"
print_success "Config written to $CONF_FILE"

print_msg "Restarting PipeWire as $SUDO_USER..."

if sudo -u "$SUDO_USER" \
	DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u "$SUDO_USER")/bus" \
	XDG_RUNTIME_DIR="/run/user/$(id -u "$SUDO_USER")" \
	systemctl --user restart pipewire pipewire-pulse; then
	print_success "PipeWire restarted"
else
	print_warning "Failed to restart PipeWire, do it yourself 🤷"
fi

print_msg "Verifying virtual source..."
sleep 2
if sudo -u "$SUDO_USER" \
	DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u "$SUDO_USER")/bus" \
	XDG_RUNTIME_DIR="/run/user/$(id -u "$SUDO_USER")" \
	pactl list sources short | grep -i noise; then
	print_success "Virtual source do be there though"
else
	print_warning "Virtual source not detected, check: journalctl --user -u pipewire -n 50"
fi
