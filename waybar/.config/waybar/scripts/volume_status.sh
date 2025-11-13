#!/usr/bin/env bash

get_status() {
  VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | tr -d '%')
  MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

  if [ "$MUTED" = "yes" ] || [ "$VOLUME" -eq 0 ]; then
    echo '{"class": "muted"}'
  elif [ "$VOLUME" -lt 10 ]; then
    echo '{"class": "volume-0"}'
  elif [ "$VOLUME" -lt 25 ]; then
    echo '{"class": "volume-1"}'
  elif [ "$VOLUME" -lt 40 ]; then
    echo '{"class": "volume-2"}'
  else
    echo '{"class": "volume-3"}'
  fi
}

get_status

# listen pipewire and pulseaudio events
pactl subscribe | while read -r event; do
  if   echo "$event" | grep -q "sink"; then
    get_status
  fi
done
