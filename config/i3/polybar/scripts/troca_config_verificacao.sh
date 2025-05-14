#!/bin/bash

# Caminho para o arquivo de configuração
CONFIG_FILE="$HOME/.config/i3/polybar/config.ini"

# Verifica qual linha está comentada e ajusta de acordo
if grep -q "^#modules-left = launcher i3 term files browser theme cpuBar" "$CONFIG_FILE"; then
    # Se a primeira linha estiver comentada, descomenta ela e comenta a segunda
    sed -i \
        -e '/^#modules-left = launcher i3 term files browser theme cpuBar$/s/^#//' \
        -e '/^modules-left = launcher i3_numbers term files browser theme cpuBar$/s/^/#/' \
        "$CONFIG_FILE"
else
    # Caso contrário, comenta a primeira linha e descomenta a segunda
    sed -i \
        -e '/^modules-left = launcher i3 term files browser theme cpuBar$/s/^/#/' \
        -e '/^#modules-left = launcher i3_numbers term files browser theme cpuBar$/s/^#//' \
        "$CONFIG_FILE"
fi

# Reinicia o i3wm para aplicar as mudanças
#i3-msg restart
~/.config/i3/polybar/launch.sh

echo "Troca realizada e configurações recarregadas com sucesso!"
