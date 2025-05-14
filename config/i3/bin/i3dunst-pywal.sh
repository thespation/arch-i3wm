#!/bin/bash

# Verifica se as cores do Pywal estão disponíveis
if [ -f "$HOME/.cache/wal/colors.sh" ]; then
    . "$HOME/.cache/wal/colors.sh"
else
    echo "Erro: Arquivo de cores do Pywal não encontrado!"
    exit 1
fi

# Confirma que as cores foram carregadas corretamente
if [ -z "$color7" ] || [ -z "$color0" ] || [ -z "$color2" ] || [ -z "$color4" ] || [ -z "$color5" ]; then
    echo "Erro: Cores não carregadas corretamente do Pywal."
    exit 1
fi

# Caminho do arquivo original e temporário do Dunst
dunst_config="$HOME/.config/i3/dunstrc"
dunst_temp="$HOME/.config/i3/dunstrc.tmp"

# Cria um novo arquivo de configuração com as cores atualizadas
cat <<EOF > "$dunst_temp"
[global]

monitor = 0
follow = mouse

width = (300, 400)
origin = bottom-right
offset = (20, 60)
scale = 0

notification_limit = 20
indicate_hidden = yes

transparency = 0
corner_radius = 6

gap_size = 4
separator_height = 1
separator_color="$color7"

padding = 15
horizontal_padding = 15
text_icon_padding = 0

frame_width = 0
frame_color="$color0"

sort = no
idle_threshold = 0

font = JetBrainsMono NF Medium 9
line_height = 0

markup = full
format = "<span size='xx-large' font_desc='Cantarell 9' weight='bold' foreground='#7aa2f7'>%s</span>\n%b"
alignment = center
vertical_alignment = center

show_age_threshold = 60
ignore_newline = no
stack_duplicates = false
hide_duplicate_count = true

show_indicators = yes

enable_recursive_icon_lookup = true
icon_position = left
min_icon_size = 60
max_icon_size = 90
icon_corner_radius = 6

sticky_history = yes
history_length = 25

browser = /usr/bin/xdg-open
always_run_script = true
ignore_dbusclose = false

force_xinerama = false

mouse_left_click = close_current
mouse_middle_click = do_action, close_current
mouse_right_click = close_all

progress_bar = true
progress_bar_height = 10
progress_bar_frame_width = 0
progress_bar_min_width = 125
progress_bar_max_width = 250
progress_bar_corner_radius = 5

title = Dunst
class = Dunst

[urgency_low]
timeout = 3
background="$color0"
foreground="$color2"

[urgency_normal]
timeout = 5
background="$color0"
foreground="$color4"

[urgency_critical]
timeout = 0
background="$color0"
foreground="$color5"
EOF

# Substitui o arquivo original pelo novo
mv "$dunst_temp" "$dunst_config"

# Reinicia o Dunst para aplicar as mudanças corretamente
#sleep 5
killall dunst
#sleep 5
dunst -config "$dunst_config" &
