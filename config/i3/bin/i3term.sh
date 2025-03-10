#!/usr/bin/env bash

## Launch Kitty with i3wm config

# Garantir que a variável DBUS_SESSION_BUS_ADDRESS esteja configurada
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus
fi

# Defina o caminho para o arquivo de configuração do Kitty
CONFIG="$HOME/.config/i3/kitty/kitty.conf"

if [ "$1" == "--float" ]; then
    # Lança o Kitty com a classe 'kitty-float'
    kitty --class 'kitty-float' --config "$CONFIG" &
    
    # Torna a janela flutuante usando i3-msg
    i3-msg "[class='kitty-float'] floating enable"
elif [ "$1" == "--full" ]; then
    # Lança o Kitty com a classe 'Fullscreen'
    kitty --class 'Fullscreen' --config "$CONFIG" \
          --window-startup-mode=fullscreen --window-padding 30 --window-opacity 0.95 \
          --font-size 9
else
    kitty --config "$CONFIG"
fi
