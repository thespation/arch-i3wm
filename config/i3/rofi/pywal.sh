#!/usr/bin/env bash

# Arquivos de cores
PFILE="$HOME/.config/i3/polybar/colors.ini"
RFILE="$HOME/.config/i3/rofi/rofi/colors.rasi"
WFILE="$HOME/.cache/wal/colors.sh"

# Obter cores
pywal_get() {
    wal -i "$1" -q -t
}

# Alterar cores
change_color() {
    # polybar
    sed -i -e "s/background = #.*/background = $BG/g" "$PFILE"
    sed -i -e "s/foreground = #.*/foreground = $FG/g" "$PFILE"
    sed -i -e "s/primary = #.*/primary = $AC/g" "$PFILE"
    
    # rofi
    cat > "$RFILE" <<- EOF
    /* colors */

    * {
      al:    #00000000;
      bg:    ${BG}FF;
      ac:    ${AC}FF;
      se:    ${AC}26;
      fg:    ${FG}FF;
    }
EOF
    
    polybar-msg cmd restart
}

# Principal
if command -v wal &> /dev/null; then
    if [[ "$1" ]]; then
        pywal_get "$1"

        # Carregar o arquivo de cores do pywal
        if [[ -e "$WFILE" ]]; then
            . "$WFILE"
        else
            echo "O arquivo de cores não existe, saindo..."
            exit 1
        fi

        BG=$(printf "%s\n" "$background")
        FG=$(printf "%s\n" "$foreground")
        AC=$(printf "%s\n" "$color1")

        change_color
    else
        echo "[!] Por favor, insira o caminho para o wallpaper. \n"
        echo "Uso: ./pywal.sh caminho/para/imagem"
    fi
else
    echo "[!] 'pywal' não está instalado."
fi
