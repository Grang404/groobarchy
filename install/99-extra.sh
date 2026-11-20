#!/usr/bin/env bash

source "$GROOB_DIR/install/core.sh"


as_user gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
as_user gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
as_user gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
