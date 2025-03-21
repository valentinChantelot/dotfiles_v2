#!/usr/bin/bash

# This script automatically changes the desktop wallpaper every hour.
# It selects a random image from a specified directory and sets it as the wallpaper using the swww tool. If no wallpapers are found, it falls back to a default wallpaper or use a blank one.
# The script runs in an infinite loop, ensuring continuous wallpaper rotation.

WALLPAPERS_DIR="$HOME/.config/backgrounds"
CURRENT_WALLPAPER_DIR="$HOME/.config/backgrounds/current"
FALLBACK_WALLPAPER=$(find "$WALLPAPERS_DIR" -type f -iname "default.*" | head -n 1)

# Create all needed directories if they don't exists
mkdir -p "$CURRENT_WALLPAPER_DIR"

set_wallpaper() {
  local wallpaper=$1

  # Remove current wallpaper
  rm -f "$CURRENT_WALLPAPER_DIR"/*

  # Copy the new current wallpaper
  cp "$wallpaper" "$CURRENT_WALLPAPER_DIR/$(basename "$wallpaper")"

  # check if the command to set the wallpaper with swww is successful
  if ! swww img "$wallpaper" --transition-type outer; then
    notify-send "👾⚠️ Outch ! SWWW (wallpaper) issue" "No wallpaper found. Fix me or you will have that shitty black wallpaper all day long."
    echo "👾⚠️ No wallpaper found. Fix me or you will have that shitty black wallpaper all day long"

    # check if the fallback wallpaper file exists.
    # if it does, set it as the wallpaper
    # otherwise, use a blank one
    [ -f "$FALLBACK_WALLPAPER" ] && swww img "$FALLBACK_WALLPAPER" || swww clear
  else
    echo "👾 A new wallpaper has been set."
  fi

  echo "👾 A new wallpaper has been set."
}

while true; do
  # get all available wallpapers
  mapfile -t wallpapers < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.webp" \))

  # if there are no available wallpapers, use the default one ;
  # and if there is no default, use a blank one.
  if [ "${#wallpapers[@]}" -eq 0 ]; then
    if [ -f "$FALLBACK_WALLPAPER" ]; then
      set_wallpaper "$FALLBACK_WALLPAPER"
    else
      swww clear
      notify-send "👾⚠️ Outch ! SWWW (wallpaper) issue" "No wallpaper found. Fix me or you will have that shitty black wallpaper all day long."
      echo "👾⚠️ No wallpaper found. Fix me or you will have that shitty black wallpaper all day long"
    fi

    # wait for an hour and try again
    sleep 3600
    continue
  fi

  # get and set a random wallpaper in the available wallpaper list
  RANDOM_WALLPAPER=$(printf "%s\n" "${wallpapers[@]}" | shuf -n 1)
  set_wallpaper "$RANDOM_WALLPAPER"

  # wait for an hour and rerun the script
  sleep 3600
done
