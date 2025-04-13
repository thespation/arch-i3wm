#!/bin/bash

# Cores
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

# Função para exibir mensagens de erro ou sucesso
log_message() {
    local message=$1
    local color=$2
    local symbol=$3
    echo -e "${color}$symbol $message${NC}"
}

# Função para verificar o status de um comando e exibir mensagem
check_status() {
    local status=$1
    local success_message=$2
    local error_message=$3

    if [ "$status" -eq 0 ]; then
        log_message "$success_message" "$GREEN" "[✔]"
    else
        log_message "$error_message" "$RED" "[✖]"
        exit 1
    fi
}

# Mensagem inicial
log_message "
==========================================
┌─┐┬  ┌─┐┌┐┌┌─┐┌┐┌┌┬┐┌─┐  ┌─┐┌─┐┌┐┌┌─┐┬┌─┐
│  │  │ ││││├─┤│││ │││ │  │  │ ││││├┤ ││ ┬
└─┘┴─┘└─┘┘└┘┴ ┴┘└┘─┴┘└─┘  └─┘└─┘┘└┘└  ┴└─┘" "$GREEN" ""

# Diretório temporário para o repositório
REPO_DIR="/tmp/arch-i3wm"

# Verificar se o repositório já existe
if [ ! -d "$REPO_DIR" ]; then
    # Clonar o repositório se não existir
    git clone https://github.com/thespation/arch-i3wm "$REPO_DIR" &>/dev/null
    check_status $? "Repositório clonado com sucesso" "Erro ao clonar o repositório"
else
    log_message "Repositório já existe em $REPO_DIR. Pulando clonagem." "$YELLOW" "[✔]"
fi

# Conceder permissões de execução
chmod -R +x "$REPO_DIR" &>/dev/null
check_status $? "Permissões de execução concedidas com sucesso" "Erro ao conceder permissões"

# Copiar pastas de configuração para ~/.config com backup
CONFIG_SRC="$REPO_DIR/config"
CONFIG_DEST="$HOME/.config"
BACKUP_DIR="$CONFIG_DEST/backup$(date +%Y%m%d%H%M%S)"
mkdir -p "$BACKUP_DIR"

if [ -d "$CONFIG_SRC" ]; then
    for dir in "$CONFIG_SRC"/*; do
        if [ -d "$dir" ]; then
            dir_name=$(basename "$dir")
            if [ -d "$CONFIG_DEST/$dir_name" ]; then
                log_message "Criando backup de ~/.config/$dir_name em $BACKUP_DIR" "$YELLOW" "[✔]"
                mv "$CONFIG_DEST/$dir_name" "$BACKUP_DIR/" &>/dev/null
                check_status $? "Backup criado com sucesso" "Erro ao criar backup"
            fi
            log_message "Copiando $dir_name para ~/.config" "$YELLOW" "[✔]"
            cp -r "$dir" "$CONFIG_DEST/" &>/dev/null
            check_status $? "$dir_name copiado com sucesso\n" "Erro ao copiar $dir_name"
        fi
    done
else
    log_message "Diretório de configuração não encontrado em $CONFIG_SRC." "$RED" "[✖]"
    exit 1
fi

# Copiar arquivos para ~/.local/share sem sobrescrever os existentes
LOCALSHARE_SRC="$REPO_DIR/home/localShare"
LOCALSHARE_DEST="$HOME/.local/share"

if [ -d "$LOCALSHARE_SRC" ]; then
    log_message "Copiando arquivos para ~/.local/share sem sobrescrever" "$YELLOW" "[✔]"
    find "$LOCALSHARE_SRC" -type f | while read src_file; do
        dest_file="${LOCALSHARE_DEST}${src_file#$LOCALSHARE_SRC}"
        dest_dir=$(dirname "$dest_file")
        mkdir -p "$dest_dir"
        if [ ! -e "$dest_file" ]; then
            cp "$src_file" "$dest_file" &>/dev/null
            check_status $? "Copiado: $(basename "$src_file")" "Erro ao copiar: $(basename "$src_file")"
        fi
    done
else
    log_message "Diretório de arquivos locais não encontrado em $LOCALSHARE_SRC." "$RED" "[✖]"
    exit 1
fi

# Diretórios de origem e destino para localBin
LOCALBIN_SRC="$REPO_DIR/home/localBin"
LOCALBIN_DEST="$HOME/.local/bin"

# Criar ~/.local/bin se não existir
if [ ! -d "$LOCALBIN_DEST" ]; then
    mkdir -p "$LOCALBIN_DEST"
    log_message "Diretório $LOCALBIN_DEST criado" "$GREEN" "[✔]"
fi

# Copiar arquivos sem sobrescrever os existentes
if [ -d "$LOCALBIN_SRC" ]; then
    log_message "Copiando arquivos para ~/.local/bin sem sobrescrever" "$YELLOW" "[✔]"
    for src_file in "$LOCALBIN_SRC"/*; do
        if [ -f "$src_file" ]; then
            dest_file="$LOCALBIN_DEST/$(basename "$src_file")"
            if [ ! -e "$dest_file" ]; then
                cp "$src_file" "$dest_file"
                log_message "Copiado: $(basename "$src_file") → bin" "$GREEN" "[✔]"
            fi
        fi
    done
else
    log_message "Diretório de origem $LOCALBIN_SRC não encontrado" "$RED" "[✖]"
fi

# Copiar arquivos fehbg, Xresources e zshrc para o $HOME com backup, renomeados
FILES_TO_COPY=("fehbg" "Xresources" "zshrc")
SRC_DIR="$REPO_DIR/home"

for file in "${FILES_TO_COPY[@]}"; do
    src_file="$SRC_DIR/$file"
    dest_file="$HOME/.$file"  # Adicionando o ponto no início do nome

    if [ -f "$src_file" ]; then
        if [ -e "$dest_file" ]; then
            # Criar backup antes de copiar
            BACKUP_FILE="$HOME/backup_$(date +%Y%m%d%H%M%S)_$file"
            mv "$dest_file" "$BACKUP_FILE"
            log_message "Backup de $file criado em $BACKUP_FILE" "$YELLOW" "\n[✔]"
        fi
        # Copiar o arquivo renomeado com ponto no início
        cp "$src_file" "$dest_file"
        check_status $? "Arquivo .$file copiado para $HOME" "Erro ao copiar .$file"
    else
        log_message "$file não encontrado em $src_file" "$RED" "[✖]"
    fi
done

# Verificar e fazer backup do lightdm-gtk-greeter.conf e copiar novos arquivos
LIGHTDM_CONF="/etc/lightdm/lightdm-gtk-greeter.conf"
LIGHTDM_CONF_SRC="/tmp/arch-i3wm/lightdm/lightdm-gtk-greeter.conf"
WALLPAPER_SRC="/tmp/arch-i3wm/lightdm/01.jpg"
WALLPAPER_DEST="/usr/share/Wallpaper/01.jpg"

# Pular uma linha antes dessa parte
echo -e ""
# Verificar se o arquivo lightdm-gtk-greeter.conf existe
if [ -f "$LIGHTDM_CONF" ]; then
    # Criar backup do arquivo existente com sudo
    BACKUP_LIGHTDM_CONF="/etc/lightdm/backup_$(date +%Y%m%d%H%M%S)_lightdm-gtk-greeter.conf"
    sudo cp "$LIGHTDM_CONF" "$BACKUP_LIGHTDM_CONF"
    log_message "Backup de lightdm-gtk-greeter.conf criado em $BACKUP_LIGHTDM_CONF" "$YELLOW" "[✔]"
fi

# Copiar o novo lightdm-gtk-greeter.conf para /etc/lightdm/ com sudo
if [ -f "$LIGHTDM_CONF_SRC" ]; then
    sudo cp "$LIGHTDM_CONF_SRC" "$LIGHTDM_CONF"
    check_status $? "Arquivo lightdm-gtk-greeter.conf copiado para /etc/lightdm/" "Erro ao copiar lightdm-gtk-greeter.conf"
else
    log_message "$LIGHTDM_CONF_SRC não encontrado" "$RED" "[✖]"
fi

# Verificar se a pasta /usr/share/Wallpaper/ existe, criar se não
if [ ! -d "/usr/share/Wallpaper" ]; then
    sudo mkdir -p /usr/share/Wallpaper
    log_message "Pasta /usr/share/Wallpaper criada" "$GREEN" "[✔]"
fi

# Copiar o arquivo 01.jpg para /usr/share/Wallpaper/ com sudo
if [ -f "$WALLPAPER_SRC" ]; then
    sudo cp "$WALLPAPER_SRC" "$WALLPAPER_DEST"
    check_status $? "Wallpaper 01.jpg copiado para /usr/share/Wallpaper/" "Erro ao copiar wallpaper"
else
    log_message "$WALLPAPER_SRC não encontrado" "$RED" "[✖]"
fi

# Modificar para o zsh apenas se não for o shell atual
if [ "$(basename "$SHELL")" != "zsh" ]; then
  if pacman -Qi zsh &>/dev/null; then
    chsh -s $(which zsh)
    echo -e "${GREEN}[✔]${NC} Shell alterado para zsh"
  else
    echo -e "${RED}[x]${NC} O zsh não está instalado"
  fi
else
  echo -e "${GREEN}[✔]${NC} O shell atual já é o zsh"
fi

# Criando tema pywal e aplicando
# Papel de parede
WP="$HOME/.config/i3/wallpapers/01.jpg"
feh --bg-fill "$WP"

#Executa os scripts relacionados ao pywal
$HOME/.config/i3/polybar/scripts/pywal.sh "$WP"
$HOME/.config/i3/bin/i3dunst-pywal.sh
wal -R
