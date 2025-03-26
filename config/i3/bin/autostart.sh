#!/usr/bin/env bash
## Programas de Inicialização Automática

# Encerrar processos já em execução
_ps=(dunst ksuperkey xfce-polkit xfce4-power-manager)
for _prs in "${_ps[@]}"; do
    if [[ $(pidof ${_prs}) ]]; then
        killall ${_prs}
    fi
done

# Corrigir o cursor
xsetroot -cursor_name left_ptr

# Iniciar daemon de notificações
if [ -f ~/.config/i3/dunstrc ]; then
    dunst -config ~/.config/i3/dunstrc &
else
    echo "Configuração do dunst não encontrada!" >> ~/.config/i3/logs/autostart.log
fi

# Agente Polkit
/usr/lib/xfce-polkit/xfce-polkit &

# Habilitar gerenciamento de energia
xfce4-power-manager &

# Habilitar Teclas Super para o Menu
ksuperkey -e 'Super_L=Alt_L|F1' &
ksuperkey -e 'Super_R=Alt_L|F1' &

# Autotiling
autotiling &

# Barra do i3 (polybar)
if [ -f ~/.config/i3/polybar/launch.sh ]; then
    ~/.config/i3/polybar/launch.sh
else
    echo "Script do polybar não encontrado!" >> ~/.config/i3/logs/autostart.log
fi

# Lauch compositor
#~/.config/i3/bin/i3comp.sh

#Resolução de tela
#~/.config/i3/bin/tela.sh
