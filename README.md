# Arch-i3wm                           

Personalização pessoal para base Arch linux.<br>
Para lista do que será instalado: [repositório oficial](https://github.com/thespation/arch-i3wm/blob/22fd8c6afbd61d113c488fc8d727bbbf14652a6a/scripts/packages.sh#L61)
e [AUR](https://github.com/thespation/arch-i3wm/blob/22fd8c6afbd61d113c488fc8d727bbbf14652a6a/scripts/packages.sh#L124).

## Instalação automatizada

````
curl -O https://raw.githubusercontent.com/thespation/arch-i3wm/refs/heads/main/scripts/install.sh
chmod +x install.sh
./install.sh
````

## Temas de cores
Utilize o atalho <kbd>mod</kbd> + <kbd>t</kbd> para selecionar papel de parede desejado e as cores serão usadas para modificar o `rofi`, `polybar`, `dunst` e cores do `i3wm`:<br>
<!-- (Site para crair gif: https://ezgif.com/maker) -->

![gif02](https://github.com/user-attachments/assets/47a2fe2e-0fc7-4088-be50-5d2bdbf99d8d)

### Seletor de papel de parede

![seletorWallpaper](https://github.com/user-attachments/assets/4d2c050c-d34b-44cb-866b-4fa8be8d7c7d)

> ℹ️ informação: <br>
 Ao iniciar o seletor de papel de parede, provavelmente não exibirá as miniaturas (como na imagem acima), é preciso abri a pasta `~/.config/i3/wallpapers` com o `thunar` antes, para carregar o cache.

## Rofi utilizado
Menu de aplicativos, captura de tela, menu bluetooth, *powermenu* (menu para bloquear a tela, encerrar sessão, hibernar(caso esteja habilitado), reiniciar e desligar):

![gif02-rofi](https://github.com/user-attachments/assets/d01b44a7-582a-4239-9fae-f939085122ea)

# Teclas de atalhos</h2>
Seguem os atalhos já configurados:
<br>(Legenda: <kbd> W</kbd> = Tecla Windows, super, mod - como preferir chamar)

## Menus
| Teclas | Ação |
| --- | --- |
| <kbd>W</kbd> ou <kbd>alt</kbd> + <kbd>F1</kbd> | Menu de aplicativos |
| <kbd>W</kbd> + <kbd>w</kbd> | Mostra programas abertos (tecla Windows mais a tecla "w") |
| <kbd>W</kbd> + <kbd>x</kbd> | Menu com opções de desligamento |
| <kbd>Ctrl</kbd> + <kbd>t</kbd> | Seletor de tema |
| <kbd>W</kbd> + <kbd>s</kbd> | Captura de tela |
| <kbd>W</kbd> + <kbd>r</kbd> | Abrir como root |
| <kbd>W</kbd> + <kbd>b</kbd> | Gerenciar bluetooth |

## Comandos internos
| Teclas | Ação |
| --- | --- |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>r</kbd> | Recarregar i3wm |
| <kbd>Ctrl</kbd> + <kbd>alt</kbd> +<kbd>l</kbd> | Bloquear tela |

## Aplicativos
| Teclas | Ação |
| --- | --- |
| <kbd>W</kbd> + <kbd>Enter</kbd> | Terminal |
| <kbd>W</kbd> + <kbd>Shift</kbd> + <kbd>Enter</kbd> | Terminal modo flutuante |
| <kbd>W</kbd> + <kbd>e</kbd> | Gestor de arquivos |
| <kbd>W</kbd> + <kbd>Shift</kbd> + <kbd>w</kbd> | Navegador web |
| <kbd>W</kbd> + <kbd>Shift</kbd> + <kbd>e</kbd> | Geany |
| <kbd>W</kbd> + <kbd>c</kbd> | Fechar janela em foco |

----
Referencia: foi usado o github [gh0stzk](https://github.com/gh0stzk/dotfiles) como inspiração e os arquivos `zsh`.
