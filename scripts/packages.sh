#!/bin/bash

# Cores
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

# Spinner
spinner() {
  local pid=$!
  local delay=0.1
  local spinstr='|/-\'
  while ps -p $pid &>/dev/null; do
    printf "\r [%c]  " "$spinstr"
    spinstr=${spinstr#?}${spinstr%"${spinstr#?}"}
    sleep $delay
  done
  # Apenas limpar a linha sem pular para a próxima
  printf "\r      \r"
}

# Iniciar o spinner sem bloquear
start_spinner() {
  local msg=$1
  echo -ne "$msg\r"
  (
    local delay=0.1
    local spinstr='|/-\'
    while :; do
      for i in `seq 0 3`; do
        echo -ne "[${spinstr:$i:1}]"
        sleep $delay
        echo -ne "\b\b\b"
      done
    done
  ) &
  spinner_pid=$!
}

# Parar o spinner
stop_spinner() {
  kill $spinner_pid &>/dev/null
  wait $spinner_pid 2>/dev/null
  echo -ne "\r\033[K"  # Limpar a linha
}

# Arte ASCII inicial
echo -e "${GREEN}
===========================================================
┬┌┐┌┌─┐┌┬┐┌─┐┬  ┌─┐┬─┐  ┌─┐┌─┐┌─┐┌─┐┌┬┐┌─┐┌─┐  ┌┐ ┌─┐┌─┐┌─┐
││││└─┐ │ ├─┤│  ├─┤├┬┘  ├─┘├─┤│  │ │ │ ├┤ └─┐  ├┴┐├─┤└─┐├┤ 
┴┘└┘└─┘ ┴ ┴ ┴┴─┘┴ ┴┴└─  ┴  ┴ ┴└─┘└─┘ ┴ └─┘└─┘  └─┘┴ ┴└─┘└─┘${NC}"

# Atualizar o sistema antes de instalar pacotes (evitar spinner para senha)
echo -e "${YELLOW}Atualizando o sistema...${NC}"
sudo pacman -Syu --noconfirm &>/dev/null  # Solicitação de senha sem spinner
if [ $? -ne 0 ]; then
  echo -e "${RED}[x]${NC} Erro: autenticação falhou."
  exit 1
fi
echo -e "${GREEN}[✔]${NC} Sistema atualizado"

# Lista de pacotes
packages=(
  arandr autotiling base base-devel bat chromium dmenu dunst eza feh ffmpegthumbnailer
  geany geany-plugins git grub gst-plugin-pipewire hsetroot htop i3-wm
  i3lock iwd kitty libpulse linux-firmware lxappearance maim mpc nano
  neofetch network-manager-applet networkmanager noto-fonts-emoji picom
  pipewire polybar rofi smartmontools strace thunar tree tumbler
  unzip viewnior wget wireless_tools wireplumber xclip xcolor xdg-user-dirs
  xdg-utils xfce4-power-manager xfce4-settings xorg-xinit
  xorg-xsetroot zenity zsh zsh-autosuggestions
  zsh-history-substring-search zsh-syntax-highlighting
)

# Verificar e instalar pacotes
install_package() {
  local pkg=$1
  if pacman -Qi $pkg &>/dev/null; then
    echo -e "${GREEN}[✔]${NC} $pkg já está instalado."
  else
    echo -e "\nInstalando $pkg..."
    (sudo pacman -S --noconfirm $pkg) & spinner
    wait
    if pacman -Qi $pkg &>/dev/null; then
      echo -e "${GREEN}[✔]${NC} $pkg instalado com sucesso"
    else
      echo -e "${RED}[x]${NC} Erro ao instalar $pkg"
    fi
  fi
}

# Iterar sobre os pacotes
for pkg in "${packages[@]}"; do
  install_package $pkg
done

# Mensagem indicando instalação de pacotes do AUR
echo -e "${GREEN}
========================================================
┬┌┐┌┌─┐┌┬┐┌─┐┬  ┌─┐┬─┐  ┌─┐┌─┐┌─┐┌─┐┌┬┐┌─┐┌─┐  ┬ ┬┌─┐┬ ┬
││││└─┐ │ ├─┤│  ├─┤├┬┘  ├─┘├─┤│  │ │ │ ├┤ └─┐  └┬┘├─┤└─┬┘
┴┘└┘└─┘ ┴ ┴ ┴┴─┘┴ ┴┴└─  ┴  ┴ ┴└─┘└─┘ ┴ └─┘└─┘   ┴ ┴ ┴ ┴ ${NC}"

# Ativação e instalação do yay sem spinner durante a solicitação de senha
if ! command -v yay &>/dev/null; then
  echo -e "${YELLOW}Abilitando yay, aguarde...${NC}"
  
  # Verificar se a pasta já existe
  if [ ! -d "/tmp/yay-bin" ]; then
    # Clonar o repositório
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
  fi
  cd /tmp/yay-bin

  # Solicitar senha antes de instalar dependências
  sudo -k
  echo -e "${YELLOW}Forneça a senha para instalar dependências necessárias...${NC}"
  sudo pacman -S --needed --noconfirm base-devel
  
  echo -e "${YELLOW}Instalando yay...${NC}"
  # Executar makepkg como usuário normal
  sudo -u $USER makepkg -si --noconfirm

  cd -
  rm -rf /tmp/yay-bin
  
  if command -v yay &>/dev/null; then
    echo -e "${GREEN}[✔]${NC} yay instalado com sucesso"
  else
    echo -e "${RED}[x]${NC} Erro ao instalar o yay"
  fi
else
  echo -e "${GREEN}[✔]${NC} yay já está instalado"
fi

# Lista de pacotes do AUR
aur_packages=(
  ksuperkey pywal-git xfce-polkit
)

# Verificar e instalar pacotes do AUR
install_aur_package() {
  local pkg=$1
  if yay -Qi $pkg &>/dev/null; then
    echo -e "${GREEN}[✔]${NC} $pkg já está instalado."
  else
    echo -e "\nInstalando $pkg pelo AUR..."
    (yay -S --noconfirm $pkg) & spinner
    wait
    if yay -Qi $pkg &>/dev/null; then
      echo -e "${GREEN}[✔]${NC} $pkg instalado com sucesso"
    else
      echo -e "${RED}[x]${NC} Erro ao instalar o $pkg"
    fi
  fi
}

# Iterar sobre os pacotes do AUR
for pkg in "${aur_packages[@]}"; do
  install_aur_package $pkg
done
