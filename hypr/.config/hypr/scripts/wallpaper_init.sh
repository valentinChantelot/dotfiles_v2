#!/usr/bin/bash

# This script automatically starts swww - the wallpaper engine,
# and load a default background if it exists, or use a blank screen if it does not.

# init and start swww - the wallpaper engine
if ! pgrep -x "swww-daemon" >/dev/null; then
  swww init
  swww-daemon --format xrgb
  sleep 0.5
  echo "👾 Wallpaper daemon is working."
fi

WALLPAPERS_DIR="$HOME/.config/wallpapers"

# get the default wallpaper
WALLPAPER=$(find "$WALLPAPERS_DIR" -type f -name "default.*" | head -n 1)

# if there is no default wallpaper, use a blanck one
if [ -z "$WALLPAPER" ]; then
  notify-send "⚠️ Outch ! SWWW (wallpaper) startup issue" "No default wallpaper found."
  echo "⚠️ Outch ! SWWW (wallpaper) startup issue. No default swww wallpaper found. Error in .config/hypr/scripts/wallpaper_init.sh"
  swww clear
  exit 1
fi

swww img "$WALLPAPER" --transition-type=outer
echo "👾 Default wallpaper has been set on startup."