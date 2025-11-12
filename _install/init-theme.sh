#!/bin/bash

THEMES_DIR="$HOME/.config/themes"
LIGHT_DIR="$THEMES_DIR/light"
DARK_DIR="$THEMES_DIR/dark"
CURRENT_THEME_DIR="$THEMES_DIR/current"
STATE_FILE="$HOME/.config/.current_theme"

if [[ ! -d "$LIGHT_DIR" ]] || [[ ! -d "$DARK_DIR" ]]; then
    echo "Error: please use stow to init themes first"
    exit 1
fi

echo "light" > "$STATE_FILE"
ln -sf "$LIGHT_DIR" "$CURRENT_THEME_DIR"

echo "Themes initialized with light theme"
echo "Use toggle-theme.sh to switch between themes"