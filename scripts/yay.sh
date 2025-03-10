#!/usr/bin/env bash
# Desenvolvido pelo William Santos
# contato: thespation@gmail.com ou https://github.com/thespation

# Cores (tabela de cores: https://gist.github.com/avelino/3188137)
VERM="\033[1;31m"	#Deixa a saída na cor vermelho
VERD="\033[0;32m"	#Deixa a saída na cor verde
CIAN="\033[0;36m"	#Deixa a saída na cor ciano
NORM="\033[0m"		#Volta para a cor padrão

# Alias de instalação

APPS="base-devel git" 				#Apps base para instalação do Yay
GIT='git clone'					#Responsável por clonar o repositório
NCONF='--noconfirm'				#Instalação sem confirmação
REPO="https://aur.archlinux.org/yay.git" 	#Repositório

set -e #Interrompe, em caso de erro

# Inicia instalação
ETAPA1 () {
echo -e "${CIAN}[ ] Este assistente habilitará o YAY em seu sistema" ${NORM}
	sudo pacman -S --needed ${APPS} ${NCONF}
echo -e "${VERD}[*] Pacotes iniciais necessários instalados (${APPS})" ${NORM}

if [[ -d /tmp/yay ]]; then #Verifica se repositório já foi baixado
	ETAPA2
else
	echo -e "${CIAN}[ ] Baixar repositório ${REPO}" ${NORM}
		cd /tmp/ && ${GIT} ${REPO}
	echo -e "${VERD}[*] Repositório na pasta temporária" ${NORM}
	ETAPA2
fi
}

ETAPA2 () {
echo -e "${CIAN}[ ] Iniciar processo de instalação" ${NORM}
	cd /tmp/yay && makepkg -si &&
echo -e "${VERD}[*] Yay instalado e habilitado para uso" ${NORM}

echo -e "${CIAN}[ ] Iniciar processo atualização" ${NORM}
	yay -Syu ${NCONF}
echo -e "${VERD}[*] Atualizado com sucesso" ${NORM}
}

# Iniciar instalação
clear; ETAPA1
