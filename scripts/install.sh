#!/bin/bash

# Cores para logs
GREEN='\033[0;32m'
NC='\033[0m'

# URLs dos scripts
URLS=(
    "https://raw.githubusercontent.com/thespation/arch-i3wm/refs/heads/main/scripts/packages.sh"
    "https://raw.githubusercontent.com/thespation/arch-i3wm/refs/heads/main/scripts/files.sh"
    "https://raw.githubusercontent.com/thespation/arch-i3wm/refs/heads/main/scripts/themes.sh"
    "https://raw.githubusercontent.com/thespation/arch-i3wm/refs/heads/main/scripts/icons.sh"
)

# Função para executar scripts
execute_script() {
    curl -s "${1}" | bash
}

# Função para exibir o cabeçalho com arte ASCII e o menu
show_menu() {
    echo -e "${GREEN}
=========================================================
┬┌┐┌┌─┐┌┬┐┌─┐┬  ┌─┐┌─┐  ┌─┐┬ ┬┌┬┐┌─┐┌┬┐┌─┐┌┬┐┬┌─┐┌─┐┌┬┐┌─┐
││││└─┐ │ ├─┤│  ├─┤│ │  ├─┤│ │ │ │ ││││├─┤ │ │┌─┘├─┤ ││├─┤
┴┘└┘└─┘ ┴ ┴ ┴┴─┘┴ ┴└─┘  ┴ ┴└─┘ ┴ └─┘┴ ┴┴ ┴ ┴ ┴└─┘┴ ┴─┴┘┴ ┴${NC}"

    echo -e "Escolha uma das opções abaixo:"
    
    for i in {1..4}; do
        case $i in
            1)
                option_name="Instalar Pacotes base"
                ;;
            2)
                option_name="Copiar configs personalizadas"
                ;;
            3)
                option_name="Acrescentar Temas personalizados"
                ;;
            4)
                option_name="Acrescentar Icones personalizados"
                ;;
        esac

        if [[ " ${chosen[@]} " =~ " $i " ]]; then
            echo "$i) $option_name [✔]"
        else
            echo "$i) $option_name [ ]"
        fi
    done

    echo "5) Todas as opções acima"
}

# Armazenar as opções escolhidas
chosen=()

# Loop do menu
while true; do
    show_menu
    # Solicitar escolha do usuário
    read -p "Digite o número da opção desejada (ou '0' para sair): " choice

    case $choice in
        1) 
            if [[ ! " ${chosen[@]} " =~ " 1 " ]]; then
                execute_script "${URLS[0]}"
                chosen+=("1")
            fi
            ;;
        2)
            if [[ ! " ${chosen[@]} " =~ " 2 " ]]; then
                execute_script "${URLS[1]}"
                chosen+=("2")
            fi
            ;;
        3)
            if [[ ! " ${chosen[@]} " =~ " 3 " ]]; then
                execute_script "${URLS[2]}"
                chosen+=("3")
            fi
            ;;
        4)
            if [[ ! " ${chosen[@]} " =~ " 4 " ]]; then
                execute_script "${URLS[3]}"
                chosen+=("4")
            fi
            ;;
        5)
            # Executar todas as opções se a opção 5 for escolhida
            for i in {0..3}; do
                if [[ ! " ${chosen[@]} " =~ " $((i+1)) " ]]; then
                    execute_script "${URLS[$i]}"
                    chosen+=("$((i+1))")
                fi
            done
            echo "Todas as opções foram executadas."
            ;;
        0)
            echo "Saindo do menu."
            break
            ;;
        *)
            echo "Opção inválida! Tente novamente."
            ;;
    esac
done
