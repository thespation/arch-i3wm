#!/bin/bash

# Obter a URL da imagem do dia no Bing
urlpath=$(curl -s "https://www.bing.com/HPImageArchive.aspx?format=rss&idx=0&n=1&mkt=en-US" | \
          xmllint --xpath "/rss/channel/item/link/text()" - | \
          sed 's/1366x768/1920x1080/g')
# Obter o tema GTK atual a partir do arquivo settings.ini
THEME=$(grep -i "gtk-theme-name" "$HOME/.config/gtk-3.0/settings.ini" | cut -d'=' -f2 | tr -d '[:space:]')

# Verifica se o tema foi encontrado
if [[ -z "$THEME" ]]; then
    zenity --error --text="Não foi possível obter o tema GTK atual do arquivo settings.ini!"
    exit 1
fi

# Define o tema para o Zenity
export GTK_THEME="$THEME"

# Verificar se a URL foi obtida corretamente
if [[ -z "$urlpath" ]]; then
    zenity --error --text="Não foi possível obter a imagem do Bing!"
    exit 1
fi

# Baixar a imagem para um diretório
WP="$HOME/.config/i3/wallpapers/bing_wallpaper.jpg"
curl -s "https://www.bing.com$urlpath" -o "$WP"

# Aplicar o papel de parede com feh
feh --bg-scale "$WP"

# Executar os scripts relacionados ao Pywal
SCRIPTS=(
    "wal -i $WP"
    "$HOME/.config/i3/polybar/scripts/pywal.sh $WP"
    "$HOME/.config/i3/bin/i3dunst-pywal.sh"
)

for script in "${SCRIPTS[@]}"; do
    if $script; then
        notify-send "Tema Atualizado" "✅ Novo esquema de cores, baseadas no bing."
    fi
done
