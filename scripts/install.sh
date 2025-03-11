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

# Menu de opções
echo -e "Escolha uma das opções abaixo:
1) Instalar pacotes
2) Copiar personalizações
3) Instalar temas personalizados
4) Instalar ícones personalizados
5) Todas as opções acima"

# Solicitar escolha do usuário
read -p "Digite o número da opção desejada: " choice

# Executar com base na escolha
case $choice in
    1) execute_script "${URLS[0]}" ;;
    2) execute_script "${URLS[1]}" ;;
    3) execute_script "${URLS[2]}" ;;
    4) execute_script "${URLS[3]}" ;;
    5) 
        for url in "${URLS[@]}"; do
            execute_script "$url"
        done
        ;;
    *) echo "Opção inválida!" ;;
esac
