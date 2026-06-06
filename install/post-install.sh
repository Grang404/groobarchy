#!/usr/bin/env bash
exec >"$GROOB_DIR/logs/post-install.log" 2>&1

AUTOSTART="$DOTS/hypr/shared/autostart.lua"
BOOT_SCRIPT="$GROOB_DIR/install/post-install.sh"

STEPS=8
STEP=0

NOTIF_ID=$(notify-send -p -h int:value:0 "Groobarchy" "Starting post-setup...")

smooth_to() {
	local target=$1
	local label=$2
	local current=$((STEP * 100 / STEPS))
	local diff=$((target - current))
	local ticks=10
	local i
	for i in $(seq 1 $ticks); do
		local pct=$((current + diff * i / ticks))
		notify-send -r "$NOTIF_ID" \
			-h int:value:$pct \
			"Groobarchy" "$label" >/dev/null
		sleep 0.05
	done
}

progress() {
	STEP=$((STEP + 1))
	local pct=$((STEP * 100 / STEPS))
	local label="[${STEP}/${STEPS}] $1"
	smooth_to $pct "$label"
	notify-send -r "$NOTIF_ID" \
		-h int:value:$pct \
		"Groobarchy" "$label" >/dev/null
}

fail() {
	notify-send -r "$NOTIF_ID" -u critical \
		-h int:value:0 \
		"Groobarchy" "Failed: $1"
	exit 1
}

progress "Starting post-setup..."

hyprpm update || fail "hyprpm update"
progress "hyprpm updated"

yes | hyprpm add https://github.com/outfoxxed/hy3 || fail "hyprpm add hy3"
progress "hy3 added"

hyprpm enable hy3 || fail "hyprpm enable hy3"
progress "hy3 enabled"

if ! awk -v cmd="$BOOT_SCRIPT" '!(/hl\.exec_cmd/ && index($0, cmd))' "$AUTOSTART" >/tmp/autostart.lua; then
	fail "patch autostart.lua"
fi
progress "autostart.lua patched"

sudo mv /tmp/autostart.lua "$AUTOSTART" || fail "move autostart.lua"
sudo chown "$(id -un)" "$AUTOSTART" || fail "chown autostart.lua"
progress "autostart.lua moved"

sudo rm -f /etc/sudoers.d/groob-post-install
sed -i 's/^--require("shared\/hy3")/require("shared\/hy3")/' "$DOTS/hypr/hyprland.lua"
progress "sudoers cleaned, hy3 require uncommented"

hyprctl reload || notify-send -r "$NOTIF_ID" -u normal "Groobarchy" "hyprctl reload failed (non-fatal)"
progress "Hyprland reloaded"

smooth_to 100 "[${STEPS}/${STEPS}] Post-setup finished!"
notify-send -r "$NOTIF_ID" -h int:value:100 \
	"Groobarchy" "[${STEPS}/${STEPS}] Post-setup finished!"

"$GROOB_DIR/bin/groob-randompaper"
