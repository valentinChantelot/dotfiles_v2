#!/usr/bin/bash

# Automatically rotates desktop wallpapers hourly using swww
# Supports fallback to default wallpaper or blank screen

WALLPAPERS_DIR="$HOME/.config/wallpapers"
CURRENT_WALLPAPER_DIR="$HOME/.config/wallpapers/current"
FALLBACK_WALLPAPER=$(find "$WALLPAPERS_DIR" -type f -iname "default.*" | head -n 1)

# Ensure necessary directories exist
mkdir -p "$CURRENT_WALLPAPER_DIR"

set_wallpaper() {
    local wallpaper=$1

    # Prepare current wallpaper directory
    rm -f "$CURRENT_WALLPAPER_DIR"/*
    cp "$wallpaper" "$CURRENT_WALLPAPER_DIR/$(basename "$wallpaper")"

    # Attempt to set wallpaper with swww
    if ! swww img "$wallpaper" --transition-type outer; then
        # Fallback mechanism
        notify-send "⚠️ Wallpaper Change Failed" "Switching to default or blank"
        echo "⚠️ Wallpaper Change Failed" "Switching to default or blank"
        [ -f "$FALLBACK_WALLPAPER" ] && swww img "$FALLBACK_WALLPAPER" || swww clear
        return 1
    fi

    echo "Wallpaper updated successfully"
}

# Infinite loop for wallpaper rotation
while true; do
    # Select a random wallpaper from supported image types
    RANDOM_WALLPAPER=$(find "$WALLPAPERS_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1)

    # Set the wallpaper
    set_wallpaper "$RANDOM_WALLPAPER"

    # Wait for an hour before next change
    sleep 3600
done