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
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

# Arte ASCII inicial site https://patorjk.com/software/taag/#p=display&h=0&f=Calvin%20S&t=instalar%20pacotes%20base
ascii_art="
===========================================================
┬┌┐┌┌─┐┌┬┐┌─┐┬  ┌─┐┬─┐  ┌─┐┌─┐┌─┐┌─┐┌┬┐┌─┐┌─┐  ┌┐ ┌─┐┌─┐┌─┐
││││└─┐ │ ├─┤│  ├─┤├┬┘  ├─┘├─┤│  │ │ │ ├┤ └─┐  ├┴┐├─┤└─┐├┤ 
┴┘└┘└─┘ ┴ ┴ ┴┴─┘┴ ┴┴└─  ┴  ┴ ┴└─┘└─┘ ┴ └─┘└─┘  └─┘┴ ┴└─┘└─┘"

# Exibe a arte ASCII inicial
echo -e "${GREEN}$ascii_art${NC}"

# Lista de pacotes
packages=(
  arandr autotiling base base-devel bat chromium dmenu dunst eza feh ffmpegthumbnailer
  geany geany-plugins git grub gst-plugin-pipewire hsetroot htop i3-wm
  i3blocks i3lock i3status iwd kitty ksuperkey libpulse lightdm lightdm-gtk-greeter
  lightdm-gtk-greeter-settings linux-firmware linux-lts lxappearance maim mpc nano
  neofetch network-manager-applet networkmanager nitrogen noto-fonts-emoji picom
  pipewire polybar pywal-git ranger rofi smartmontools strace thunar tree tumbler
  unzip viewnior vim wget wireless_tools wireplumber xclip xcolor xdg-user-dirs
  xdg-utils xf86-video-vmware xfce-polkit xfce4-power-manager xfce4-settings xorg-xinit
  xorg-xsetroot xss-lock xterm yad zenity zram-generator zsh zsh-autosuggestions
  zsh-history-substring-search zsh-syntax-highlighting
)

# Verificar e instalar pacotes
install_package() {
  local pkg=$1
  if pacman -Qi $pkg &>/dev/null; then
    echo -e "${GREEN}[✔] $pkg já está instalado.${NC}"
  else
    echo -e "${GREEN}Instalando $pkg...${NC}"
    (sudo pacman -S --noconfirm $pkg &>/dev/null) & spinner
    if pacman -Qi $pkg &>/dev/null; then
      echo -e "${GREEN}[✔] $pkg instalado com sucesso!${NC}"
    else
      echo -e "${RED}[✖] Erro ao instalar $pkg.${NC}"
    fi
  fi
}

# Iterar sobre os pacotes
for pkg in "${packages[@]}"; do
  install_package $pkg
done

# Nova mensagem ao final
final_message="┌─┐┌─┐┌─┐┌─┐┌┬┐┌─┐┌─┐  ┬┌┐┌┌─┐┌┬┐┌─┐┬  ┌─┐┌┬┐┌─┐┌─┐
├─┘├─┤│  │ │ │ ├┤ └─┐  ││││└─┐ │ ├─┤│  ├─┤ │││ │└─┐
┴  ┴ ┴└─┘└─┘ ┴ └─┘└─┘  ┴┘└┘└─┘ ┴ ┴ ┴┴─┘┴ ┴─┴┘└─┘└─┘
==================================================="

# Exibe a nova mensagem ao final
echo -e "${GREEN}$final_message${NC}"
