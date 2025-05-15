#!/bin/bash

# Cores
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

# Função spinner simplificada
spinner() {
  local pid=$!
  local spinstr='|/-\\'
  while ps -p $pid &>/dev/null; do
    printf "\r [%c]  " "$spinstr"
    spinstr=${spinstr#?}${spinstr%"${spinstr#?}"}
    sleep 0.1
  done
  printf "\r      \r"
}

# Atualizar o sistema
update_system() {
  echo -e "${YELLOW}Atualizando o sistema...${NC}"
  sudo pacman -Syu --noconfirm
  spinner
  echo -e "${GREEN}[✔]${NC} Sistema atualizado"
}

# Instalar pacotes de uma lista
install_packages() {
  local manager=$1
  shift
  local packages=("$@")
  for pkg in "${packages[@]}"; do
    if $manager -Qi $pkg &>/dev/null; then
      echo -e "${GREEN}[✔]${NC} $pkg já está instalado."
    else
      echo -e "\n${YELLOW}Instalando $pkg...${NC}"
      $manager -S --noconfirm $pkg &>/dev/null &
      spinner
      if $manager -Qi $pkg &>/dev/null; then
        echo -e "${GREEN}[✔]${NC} $pkg instalado com sucesso"
      else
        echo -e "${RED}[x]${NC} Erro ao instalar $pkg"
      fi
    fi
  done
}

# Configurar e instalar yay
install_yay() {
  if ! command -v yay &>/dev/null; then
    echo -e "${YELLOW}Instalando yay...${NC}"
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin &>/dev/null
    cd /tmp/yay-bin && makepkg -si --noconfirm &>/dev/null
    cd - &>/dev/null
    if command -v yay &>/dev/null; then
      echo -e "${GREEN}[✔]${NC} yay instalado com sucesso"
    else
      echo -e "${RED}[x]${NC} Erro ao instalar yay"
    fi
  else
    echo -e "${GREEN}[✔]${NC} yay já está instalado."
  fi
}

# Pacotes do repositório oficial e AUR
repo_packages=( \
  arandr autotiling baobab base base-devel bat catfish chromium \
  dmenu dunst eza feh ffmpegthumbnailer geany geany-plugins git \
  gst-plugin-pipewire gvfs hsetroot htop i3-wm i3lock iwd kitty \
  libpulse linux-firmware lxappearance maim meld mpc nano neofetch \
  network-manager-applet networkmanager noto-fonts-emoji picom \
  pipewire polybar rofi smartmontools strace thunar thunar-archive-plugin \
  tree tumbler zip unzip unrar p7zip viewnior wget wireless_tools \
  wireplumber xarchiver xclip xcolor xdg-user-dirs xdg-utils xdotool \
  xfce4-power-manager xfce4-settings xorg-xinit xorg-xsetroot zenity zsh \
  zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting )

aur_packages=( ksuperkey pywal-git xfce-polkit )

# Fluxo principal
echo -e "${GREEN}
=========================================================
┌─┐┌┬┐┬ ┬┌─┐┬  ┬┌─┐┌─┐┬─┐  ┌─┐┬┌─┐┌┬┐┌─┐┌┬┐┌─┐
├─┤ │ │ │├─┤│  │┌─┘├─┤├┬┘  └─┐│└─┐ │ ├┤ │││├─┤
┴ ┴ ┴ └─┘┴ ┴┴─┘┴└─┘┴ ┴┴└─  └─┘┴└─┘ ┴ └─┘┴ ┴┴ ┴${NC}"
update_system
echo -e "${GREEN}
===========================================================
┬┌┐┌┌─┐┌┬┐┌─┐┬  ┌─┐┬─┐  ┌─┐┌─┐┌─┐┌─┐┌┬┐┌─┐┌─┐  ┌┐ ┌─┐┌─┐┌─┐
││││└─┐ │ ├─┤│  ├─┤├┬┘  ├─┘├─┤│  │ │ │ ├┤ └─┐  ├┴┐├─┤└─┐├┤ 
┴┘└┘└─┘ ┴ ┴ ┴┴─┘┴ ┴┴└─  ┴  ┴ ┴└─┘└─┘ ┴ └─┘└─┘  └─┘┴ ┴└─┘└─┘${NC}"
install_packages "sudo pacman" "${repo_packages[@]}"
echo -e "${GREEN}
========================================================
┬┌┐┌┌─┐┌┬┐┌─┐┬  ┌─┐┬─┐  ┌─┐┌─┐┌─┐┌─┐┌┬┐┌─┐┌─┐  ┬ ┬┌─┐┬ ┬
││││└─┐ │ ├─┤│  ├─┤├┬┘  ├─┘├─┤│  │ │ │ ├┤ └─┐  └┬┘├─┤└┬┘
┴┘└┘└─┘ ┴ ┴ ┴┴─┘┴ ┴┴└─  ┴  ┴ ┴└─┘└─┘ ┴ └─┘└─┘   ┴ ┴ ┴ ┴ ${NC}"
install_yay
install_packages "yay" "${aur_packages[@]}"
