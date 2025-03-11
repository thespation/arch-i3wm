#!/bin/bash

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

# Função para exibir o menu com o status das opções
show_menu() {
    echo -e "Escolha uma das opções abaixo:"
    
    for i in {1..4}; do
        if [[ " ${chosen[@]} " =~ " $i " ]]; then
            echo "$i) $(basename ${URLS[$((i-1))]} .sh) [✔] Já executado"
        else
            echo "$i) $(basename ${URLS[$((i-1))]} .sh) [ ] Não executado"
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
            else
                echo "Opção 1 já foi executada."
            fi
            ;;
        2)
            if [[ ! " ${chosen[@]} " =~ " 2 " ]]; then
                execute_script "${URLS[1]}"
                chosen+=("2")
            else
                echo "Opção 2 já foi executada."
            fi
            ;;
        3)
            if [[ ! " ${chosen[@]} " =~ " 3 " ]]; then
                execute_script "${URLS[2]}"
                chosen+=("3")
            else
                echo "Opção 3 já foi executada."
            fi
            ;;
        4)
            if [[ ! " ${chosen[@]} " =~ " 4 " ]]; then
                execute_script "${URLS[3]}"
                chosen+=("4")
            else
                echo "Opção 4 já foi executada."
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
