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
  local spinstr='|/-\\'
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

# Arte ASCII inicial
echo -e "${GREEN}
===========================================================
┬┌┐┌┌─┐┌┬┐┌─┐┬  ┌─┐┬─┐  ┌─┐┌─┐┌─┐┌─┐┌┬┐┌─┐┌─┐  ┌┐ ┌─┐┌─┐┌─┐
││││└─┐ │ ├─┤│  ├─┤├┬┘  ├─┘├─┤│  │ │ │ ├┤ └─┐  ├┴┐├─┤└─┐├┤ 
┴┘└┘└─┘ ┴ ┴ ┴┴─┘┴ ┴┴└─  ┴  ┴ ┴└─┘└─┘ ┴ └─┘└─┘  └─┘┴ ┴└─┘└─┘${NC}"

# Lista de pacotes
packages=(
  arandr autotiling base base-devel bat chromium dmenu dunst eza feh ffmpegthumbnailer
  geany geany-plugins git grub gst-plugin-pipewire hsetroot htop i3-wm
  i3blocks i3lock i3status iwd kitty libpulse lightdm lightdm-gtk-greeter
  lightdm-gtk-greeter-settings linux-firmware linux-lts lxappearance maim mpc nano
  neofetch network-manager-applet networkmanager nitrogen noto-fonts-emoji picom
  pipewire polybar ranger rofi smartmontools strace thunar tree tumbler
  unzip viewnior vim wget wireless_tools wireplumber xclip xcolor xdg-user-dirs
  xdg-utils xf86-video-vmware xfce4-power-manager xfce4-settings xorg-xinit
  xorg-xsetroot xss-lock xterm yad zenity zram-generator zsh zsh-autosuggestions
  zsh-history-substring-search zsh-syntax-highlighting
)

# Verificar e instalar pacotes
install_package() {
  local pkg=$1
  if pacman -Qi $pkg &>/dev/null; then
    echo -e "${GREEN}[✔]${NC} $pkg já está instalado."
  else
    echo -e "Instalando $pkg..."
    (sudo pacman -S --noconfirm $pkg &>/dev/null) & spinner
    if pacman -Qi $pkg &>/dev/null; then
      echo -e "${GREEN}[✔]${NC} $pkg instalado com sucesso!"
    else
      echo -e "${RED}[✖]${NC} Erro ao instalar $pkg."
    fi
  fi
}

# Iterar sobre os pacotes
for pkg in "${packages[@]}"; do
  install_package $pkg
done

# Ativação e instalação do yay
if ! command -v yay &>/dev/null; then
  echo -e "${YELLOW}Instalando yay...${NC}"
  sudo pacman -S --needed --noconfirm base-devel git
  git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
  cd /tmp/yay-bin
  makepkg -si --noconfirm
  cd -
  rm -rf /tmp/yay-bin
  echo -e "${GREEN}[✔]${NC} yay instalado com sucesso!"
else
  echo -e "${GREEN}[✔]${NC} yay já está instalado."
fi

# Mensagem indicando instalação de pacotes do AUR
echo -e "${GREEN}
========================================================
┬┌┐┌┌─┐┌┬┐┌─┐┬  ┌─┐┬─┐  ┌─┐┌─┐┌─┐┌─┐┌┬┐┌─┐┌─┐  ┬ ┬┌─┐┬ ┬
││││└─┐ │ ├─┤│  ├─┤├┬┘  ├─┘├─┤│  │ │ │ ├┤ └─┐  └┬┘├─┤└┬┘
┴┘└┘└─┘ ┴ ┴ ┴┴─┘┴ ┴┴└─  ┴  ┴ ┴└─┘└─┘ ┴ └─┘└─┘   ┴ ┴ ┴ ┴ ${NC}"

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
    echo -e "Instalando $pkg pelo AUR..."
    (yay -S --noconfirm $pkg &>/dev/null) & spinner
    if yay -Qi $pkg &>/dev/null; then
      echo -e "${GREEN}[✔]${NC} $pkg instalado com sucesso!"
    else
      echo -e "${RED}[✖]${NC} Erro ao instalar $pkg."
    fi
  fi
}

# Iterar sobre os pacotes do AUR
for pkg in "${aur_packages[@]}"; do
  install_aur_package $pkg
done
