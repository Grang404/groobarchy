#!/usr/bin/env bash
exec >"$GROOB_DIR/logs/post-install.log" 2>&1

hyprpm update
yes | hyprpm add https://github.com/outfoxxed/hy3

# notify-send "groobarchy setup complete"

"$GROOB_DIR/bin/groob-randompaper"

sed -i '/groob-boot-setup/d' "$HOME/.config/hypr/hyprland.conf"
rm -f /etc/sudoers.d/groob-boot-setup
