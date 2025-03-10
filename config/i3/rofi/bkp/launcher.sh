#!/usr/bin/env bash

# Import Current Theme
DIR="$HOME/.config/i3/rofi/theme"
RASI="$DIR/launcher.rasi"

# Run
rofi \
    -show drun \
	-kb-cancel Alt-F1 \
	-theme ${RASI}
