#!/bin/bash

# Verifica se as cores do Pywal estão disponíveis
[ -f "$HOME/.cache/wal/colors.sh" ] && . "$HOME/.cache/wal/colors.sh"

# Caminho do arquivo de configuração do Dunst
dunst_config="$HOME/.config/i3/dunstrc"

# Modifica apenas as cores no arquivo de configuração do Dunst
sed -i "s/^separator_color = .*/separator_color = \"$color7\"/" "$dunst_config"
sed -i "s/^frame_color = .*/frame_color = \"$color0\"/" "$dunst_config"

sed -i -E "/\[urgency_low\]/,/^$/ s/^background = .*/background = \"$color0\"/" "$dunst_config"
sed -i -E "/\[urgency_low\]/,/^$/ s/^foreground = .*/foreground = \"$color2\"/" "$dunst_config"

sed -i -E "/\[urgency_normal\]/,/^$/ s/^background = .*/background = \"$color0\"/" "$dunst_config"
sed -i -E "/\[urgency_normal\]/,/^$/ s/^foreground = .*/foreground = \"$color4\"/" "$dunst_config"

sed -i -E "/\[urgency_critical\]/,/^$/ s/^background = .*/background = \"$color0\"/" "$dunst_config"
sed -i -E "/\[urgency_critical\]/,/^$/ s/^foreground = .*/foreground = \"$color5\"/" "$dunst_config"

# Reinicia o Dunst para aplicar as mudanças
pkill dunst
setsid dunst &
