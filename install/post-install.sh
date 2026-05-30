#!/usr/bin/env bash
exec >"$GROOBDIR/logs/post-install.log" 2>&1

hyprpm update
yes | hyprpm add https://github.com/outfoxxed/hy3

# notify-send "groobarchy setup complete"

sed -i '/groob-boot-setup/d' "$HOME/.config/hypr/hyprland.conf"
rm -f /etc/sudoers.d/groob-boot-setup
