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

# Função para baixar os scripts para /tmp/thespation/arch-i3wm/scripts
download_script() {
    local url=$1
    local dest_dir="/tmp/thespation/arch-i3wm/scripts"
    
    # Criar a pasta se não existir
    [ ! -d "$dest_dir" ] && mkdir -p "$dest_dir"
    
    # Extrair o nome do arquivo da URL
    local filename=$(basename "$url")
    
    # Baixar o script e sobrescrever se já existir
    curl -s "$url" -o "$dest_dir/$filename"
    
    # Garantir permissão de execução no arquivo
    chmod +x "$dest_dir/$filename"
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
                download_script "${URLS[0]}"
                /tmp/thespation/arch-i3wm/scripts/packages.sh
                chosen+=("1")
            fi
            ;;
        2)
            if [[ ! " ${chosen[@]} " =~ " 2 " ]]; then
                download_script "${URLS[1]}"
                /tmp/thespation/arch-i3wm/scripts/files.sh
                chosen+=("2")
            fi
            ;;
        3)
            if [[ ! " ${chosen[@]} " =~ " 3 " ]]; then
                download_script "${URLS[2]}"
                /tmp/thespation/arch-i3wm/scripts/themes.sh
                chosen+=("3")
            fi
            ;;
        4)
            if [[ ! " ${chosen[@]} " =~ " 4 " ]]; then
                download_script "${URLS[3]}"
                /tmp/thespation/arch-i3wm/scripts/icons.sh
                chosen+=("4")
            fi
            ;;
        5)
            # Baixar todos os scripts se a opção 5 for escolhida
            for i in {0..3}; do
                if [[ ! " ${chosen[@]} " =~ " $((i+1)) " ]]; then
                    download_script "${URLS[$i]}"
                    /tmp/thespation/arch-i3wm/scripts/$(basename ${URLS[$i]})
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
