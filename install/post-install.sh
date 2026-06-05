#!/usr/bin/env bash
exec >"$GROOB_DIR/logs/post-install.log" 2>&1

AUTOSTART="$DOTS/hypr/shared/autostart.lua"
BOOT_SCRIPT="$GROOB_DIR/install/post-install.sh"

notify-send "Groobarchy" "Groobarchy post-setup starting..."

hyprpm update || {
	notify-send "Groobarchy" "hyprpm update failed"
	exit 1
}
yes | hyprpm add https://github.com/outfoxxed/hy3 || {
	notify-send "Groobarchy" "hyprpm add failed"
	exit 1
}
hyprpm enable hy3 || {
	notify-send "Groobarchy" "hyprpm enable failed"
	exit 1
}

if ! awk -v cmd="$BOOT_SCRIPT" '!(/hl\.exec_cmd/ && index($0, cmd))' "$AUTOSTART" >/tmp/autostart.lua; then
	notify-send "Groobarchy" "Failed to patch autostart.lua"
	exit 1
fi

sudo mv /tmp/autostart.lua "$AUTOSTART" || {
	notify-send "Groobarchy" "Failed to move autostart.lua"
	exit 1
}

sudo chown "$(id -un)" "$AUTOSTART"

sudo rm -f /etc/sudoers.d/groob-post-install

notify-send "Groobarchy" "Groobarchy post-setup finished!"
"$GROOB_DIR/bin/groob-randompaper"
