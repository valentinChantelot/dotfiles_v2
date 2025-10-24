#!/usr/bin/env bash
THEMES_DIR="$HOME/.config/themes"
CURRENT="$THEMES_DIR/current"
DEFAULT="dark"  

mkdir -p "$THEMES_DIR"

if [ ! -L "$CURRENT" ]; then
  ln -s "$THEMES_DIR/$DEFAULT" "$CURRENT"
  echo "Theme '$DEFAULT' applied."
fi
