#!/bin/bash

# Carregar as cores do pywal
source "$HOME/.cache/wal/colors.sh"

# Caminho do arquivo do tema GTK
THEME_CSS="$HOME/.themes/Kripton2/gtk-3.0/gtk.css"

# Substituir as cores no arquivo de tema com as cores do pywal
sed -i "s/@define-color bg_color.*/@define-color bg_color  $color0;/" "$THEME_CSS"
sed -i "s/@define-color fg_color.*/@define-color fg_color  $color7;/" "$THEME_CSS"
sed -i "s/@define-color selected_bg_color.*/@define-color selected_bg_color $color3;/" "$THEME_CSS"
sed -i "s/@define-color selected_fg_color.*/@define-color selected_fg_color $color0;/" "$THEME_CSS"

# Reiniciar o Thunar (caso você esteja no Xfce) ou outros aplicativos GTK
pkill -HUP thunar  # Reiniciar o Thunar para aplicar as novas cores

echo "Tema 'Kripton2' atualizado com as cores do pywal."
