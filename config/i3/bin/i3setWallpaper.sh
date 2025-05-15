#!/bin/bash

# Diretório onde estão os papéis de parede
DIR="$HOME/.config/i3/wallpapers"

# Definir referência para os ícones
ICON_THEME="/usr/share/icons/Ars/apps/scalable/colors.svg"

# Obter o tema GTK atual a partir do arquivo settings.ini
THEME=$(grep -i "gtk-theme-name" "$HOME/.config/gtk-3.0/settings.ini" | cut -d'=' -f2 | tr -d '[:space:]')

# Verifica se o tema foi encontrado
if [[ -z "$THEME" ]]; then
    zenity --error --text="Não foi possível obter o tema GTK atual do arquivo settings.ini!"
    exit 1
fi

# Define o tema para o Zenity
export GTK_THEME="$THEME"

# Verifica se o diretório de papéis de parede existe
if [[ ! -d "$DIR" ]]; then
    zenity --error --text="O diretório de papéis de parede não foi encontrado!"
    exit 1
fi

# Seleciona um papel de parede
WP=$(zenity --file-selection --title="Escolha o Papel de Parede" --filename="$DIR/" --file-filter="*.jpg *.png")

# Se o usuário não selecionou nada, sai do script
[[ -z "$WP" ]] && exit 1

# Aplica o papel de parede com feh
feh --bg-scale "$WP"

# Executa os scripts relacionados ao Pywal
SCRIPTS=(
    "$HOME/.config/i3/polybar/scripts/pywal.sh $WP"
    "$HOME/.config/i3/bin/i3dunst-pywal.sh"
    "wal -R"
)

for script in "${SCRIPTS[@]}"; do
    if $script; then
        notify-send -i "$ICON_THEME" "Tema aplicado" "✅ Executado com sucesso."
    else
        echo -e "❌ Erro ao executar: $script" >&2
        exit 1
    fi
done
