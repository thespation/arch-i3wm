#!/usr/bin/env bash

# Definir diretório padrão para capturas e ícone
CAPTURE_DIR="$(xdg-user-dir PICTURES)/Captura"
ICON_PATH="/usr/share/icons/Ars/apps/scalable/deepin-image-viewer.svg"

# Criar diretório se não existir
mkdir -p "$CAPTURE_DIR"

# Importar tema atual
DIR="$HOME/.config/i3/rofi/theme"
RASI="$DIR/screenshot.rasi"

# Elementos do tema
prompt='Captura de tela'
mesg="Salvar em: $CAPTURE_DIR"

# Opções
layout=$(grep 'USE_ICON' "$RASI" | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
    option_1=" Capturar tela inteira"
    option_2=" Capturar área"
    option_3=" Capturar janela"
    option_4=" Capturar em 5s"
    option_5=" Capturar em 10s"
else
    option_1=""
    option_2=""
    option_3=""
    option_4=""
    option_5=""
fi

# Comando Rofi
rofi_cmd() {
    rofi -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -markup-rows \
        -theme "$RASI"
}

# Passar variáveis para o menu rofi
run_rofi() {
    echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

# Captura de tela
time=$(date +%Y-%m-%d-%H-%M-%S)
file="$CAPTURE_DIR/Screenshot_${time}.png"
border='0.506,0.631,0.756'

# Notificação e visualização da captura
notify_view() {
    notify_cmd_shot="dunstify -u low -h string:x-dunst-stack-tag:obscreenshot -i $ICON_PATH"
    
    ${notify_cmd_shot} "Captura de tela" "Copiado para área de transferência."
    paplay /usr/share/sounds/freedesktop/stereo/screen-capture.oga &>/dev/null &
    
    viewnior "$file"

    sleep 1
    
    if [[ -f "$file" ]]; then
        dunstify -u low -i "$ICON_PATH" "Captura de tela" "Salva em $CAPTURE_DIR."
    else
        dunstify -u low -h string:x-dunst-stack-tag:obscreenshot -i "$ICON_PATH" "Captura de tela" "Captura excluída."
    fi
}

# Copiar captura para área de transferência
copy_shot() {
    xclip -selection clipboard -t image/png -i "$file"
}

# Contagem regressiva
countdown() {
    for sec in $(seq $1 -1 1); do
        dunstify -t 1000 -h string:x-dunst-stack-tag:screenshottimer -i "$ICON_PATH" "Captura de tela" "Capturando em: $sec"
        sleep 1
    done
}

# Funções para capturas
shotnow() {
    sleep 0.5 && maim -u -f png "$file" && copy_shot && notify_view
}

shot5() {
    countdown '5'
    sleep 1 && maim -u -f png "$file" && copy_shot && notify_view
}

shot10() {
    countdown '10'
    sleep 1 && maim -u -f png "$file" && copy_shot && notify_view
}

shotwin() {
    maim -u -f png -i $(xdotool getactivewindow) "$file" && copy_shot && notify_view
}

shotarea() {
    maim -u -f png -s -b 2 -c "${border},0.25" -l "$file" && copy_shot && notify_view
}

# Executar comando
run_cmd() {
    case "$1" in
        '--opt1') shotnow ;;
        '--opt2') shotarea ;;
        '--opt3') shotwin ;;
        '--opt4') shot5 ;;
        '--opt5') shot10 ;;
    esac
}

# Ações
chosen=$(run_rofi)
case "$chosen" in
    $option_1) run_cmd --opt1 ;;
    $option_2) run_cmd --opt2 ;;
    $option_3) run_cmd --opt3 ;;
    $option_4) run_cmd --opt4 ;;
    $option_5) run_cmd --opt5 ;;
esac
