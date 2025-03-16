#!/usr/bin/env bash

# Caminho para o diretório da configuração da Polybar
DIR="$HOME/.config/i3/polybar"

# Finaliza instâncias da Polybar que já estão rodando
killall -q polybar

# Aguarda até que os processos tenham sido encerrados
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Inicia uma barra para cada monitor detectado
if type "xrandr" > /dev/null; then
    for monitor in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$monitor polybar -q main -c "$DIR"/config.ini &
    done
else
    polybar -q main -c "$DIR"/config.ini &
fi
