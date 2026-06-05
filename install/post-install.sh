#!/usr/bin/env bash
exec >"$GROOB_DIR/logs/post-install.log" 2>&1

notify-send "Groobarchy" "Groobarchy post-setup starting..."

hyprpm update
yes | hyprpm add https://github.com/outfoxxed/hy3
hyprpm enable

awk -v cmd="$BOOT_SCRIPT" '!(/hl\.exec_cmd/ && index($0, cmd))' "$DOTS/hypr/shared/autostart.lua" > /tmp/autostart.lua && mv /tmp/autostart.lua "$DOTS/hypr/shared/autostart.lua"

sudo rm -f /etc/sudoers.d/groob-post-install


notify-send "Groobarchy" "Groobarchy post-setup finished!"
"$GROOB_DIR/bin/groob-randompaper"
