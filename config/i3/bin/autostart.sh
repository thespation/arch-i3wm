#!/usr/bin/env bash

## Copyright (C) 2020-2023 Aditya Shakya <adi1090x@gmail.com>
##
## Autostart Programs

# Kill already running process
#_ps=(picom dunst ksuperkey xfce-polkit xfce4-power-manager)
_ps=(dunst ksuperkey xfce-polkit xfce4-power-manager)
for _prs in "${_ps[@]}"; do
	if [[ `pidof ${_prs}` ]]; then
		killall -9 ${_prs}
	fi
done

# Fix cursor
xsetroot -cursor_name left_ptr

dunst -config ~/.config/i3/dunstrc &


# Polkit agent
/usr/lib/xfce-polkit/xfce-polkit &
#/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

# Enable power management
xfce4-power-manager &

# Enable Super Keys For Menu
ksuperkey -e 'Super_L=Alt_L|F1' &
ksuperkey -e 'Super_R=Alt_L|F1' &

# Restore wallpaper
#hsetroot -root -cover ~/.config/i3/wallpapers/mono.png

# Lauch notification daemon
#~/.config/i3/bin/i3dunst.sh

# Lauch compositor
#~/.config/i3/bin/i3comp.sh

#Autotiling
#exec_always --no-startup-id ~/.config/i3/bin/autotiling

#i3bar polybar
#~/.config/i3/bin/i3setWallpaper.sh
~/.config/i3/polybar/launch.sh

#Resolução da VM
#~/.config/i3/bin/tela.sh
