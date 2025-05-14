#!/bin/bash

# Função para obter o tema GTK atual
obter_tema_gtk() {
    local tema=$(grep -i "gtk-theme-name" "$HOME/.config/gtk-3.0/settings.ini" | cut -d'=' -f2 | tr -d '[:space:]')
    if [[ -z "$tema" ]]; then
        zenity --error --text="Não foi possível obter o tema GTK atual do arquivo settings.ini!"
        exit 1
    fi
    echo "$tema"
}

# Função para obter a URL do papel de parede do Bing
obter_url_bing() {
    local url=$(curl -s "https://www.bing.com/HPImageArchive.aspx?format=rss&idx=0&n=1&mkt=en-US" | \
                xmllint --xpath "/rss/channel/item/link/text()" - | \
                sed 's/1366x768/1920x1080/g')
    if [[ -z "$url" ]]; then
        zenity --error --text="Não foi possível obter a imagem do Bing!"
        exit 1
    fi
    echo "$url"
}

# Função para baixar a imagem
baixar_imagem() {
    local url="$1"
    local destino="$2"
    curl -s "https://www.bing.com$url" -o "$destino"
}

# Função para aplicar o papel de parede
aplicar_papel_de_parede() {
    feh --bg-scale "$1"
}

# Função para executar scripts relacionados ao Pywal
executar_scripts_pywal() {
    local wp="$1"
    local scripts=(
        "wal -i $wp"
        "$HOME/.config/i3/polybar/scripts/pywal.sh $wp"
        "$HOME/.config/i3/bin/i3dunst-pywal.sh"
    )

    for script in "${scripts[@]}"; do
        if $script; then
            notify-send "Tema Atualizado" "✅ Novo esquema de cores, baseado no Bing."
        fi
    done
}

# Definir o tema GTK
THEME=$(obter_tema_gtk)
export GTK_THEME="$THEME"

# Perguntar ao usuário se deseja continuar
if ! env GTK_THEME="$THEME" zenity --question --text="Deseja atualizar o papel de parede?" --title="Obter Papel de Parede Diário do Bing"; then
    exit 0
fi

# Obter a URL da imagem
urlpath=$(obter_url_bing)

# Definir diretório de destino da imagem
WP="$HOME/.config/i3/wallpapers/bing_wallpaper.jpg"

# Baixar e aplicar a imagem
baixar_imagem "$urlpath" "$WP"
aplicar_papel_de_parede "$WP"

# Executar scripts para atualizar esquema de cores
executar_scripts_pywal "$WP"
