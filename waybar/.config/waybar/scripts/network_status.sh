#!/usr/bin/env bash

if nmcli -t -f DEVICE,TYPE,STATE dev | grep -qE 'ethernet:connected'; then
  # ethernet
    echo "<span>power</span>"
  exit 0
fi

if nmcli -t -f DEVICE,TYPE,STATE dev | grep -qE 'wifi:connected'; then
  # wifi - get signal (0-100)
  SIGNAL=$(nmcli -t -f IN-USE,SIGNAL dev wifi | grep '^\*' | cut -d: -f2)

  if [ -z "$SIGNAL" ]; then
    echo "<span class=\"network-icon\ cellular-signal-off\"></span>"
    exit 0
  elif [ "$SIGNAL" -lt 30 ]; then
    echo "<span class=\"network-icon\ cellular-signal-0\"></span>"
  elif [ "$SIGNAL" -lt 60 ]; then
    echo "<span class=\"network-icon\ cellular-signal-1\"></span>"
  elif [ "$SIGNAL" -lt 85 ]; then
    echo "<span class=\"network-icon\ cellular-signal-2\"></span>"
  else
    echo "<span class=\"network-icon\ cellular-signal-3\"></span>"
  fi
  exit 0
fi

# no network
echo "<span class=\"network-icon\ cellular-signal-off\"></span>"
