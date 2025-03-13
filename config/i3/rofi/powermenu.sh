#!/usr/bin/env bash

# Import Current Theme
DIR="$HOME/.config/i3/rofi/theme"
RASI="$DIR/powermenu.rasi"

# Theme Elements
prompt="$(hostname) ($(echo $DESKTOP_SESSION))"
mesg="Tempo em uso : $(uptime -p | sed -e 's/up //g')"

# Options
layout=$(grep 'USE_ICON' "$RASI" | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
    option_1=" Lock"
    option_2=" Logout"
    option_3=" Suspend"
    option_4=" Hibernate"
    option_5=" Reboot"
    option_6=" Shutdown"
else
    option_1=""
    option_2=""
    option_3=""
    option_4=""
    option_5=""
    option_6=""
fi

# Rofi CMD
rofi_cmd() {
    rofi -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -markup-rows \
        -theme "$RASI"
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6" | rofi_cmd
}

# Execute Command
run_cmd() {
    case "$1" in
        '--opt1') i3lock -c 000000 ;;
        '--opt2') i3-msg exit ;;
        '--opt3') i3lock -c 000000 ;;
        '--opt4') systemctl hibernate ;;
        '--opt5') systemctl reboot ;;
        '--opt6') systemctl poweroff ;;
    esac
}

# Actions
chosen=$(run_rofi)
case "$chosen" in
    $option_1) run_cmd --opt1 ;;
    $option_2) run_cmd --opt2 ;;
    $option_3) run_cmd --opt3 ;;
    $option_4) run_cmd --opt4 ;;
    $option_5) run_cmd --opt5 ;;
    $option_6) run_cmd --opt6 ;;
esac
