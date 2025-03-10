#!/bin/bash
kitty -e bash -c 'sudo pacman -Syu --noconfirm; echo "Sistema atualizado com sucesso"; echo "Pressione qualquer tecla para fechar..."; read -n 1 -s'
