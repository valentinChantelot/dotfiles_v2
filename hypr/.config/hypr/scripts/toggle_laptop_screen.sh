#!/bin/bash

# check laptop monitor status
STATUS=$(hyprctl monitors | grep "eDP-1" | wc -l)

if [ "$STATUS" -eq 1 ]; then
    # is eDP-1 is active, disable it
    hyprctl keyword monitor "eDP-1,disable"
    notify-send "💻 Laptop screen disabled" "eDP-1 monitor turned off - Triggered using SUPER + F12"
else
    # is eDP-1 is inactive, enable it
    hyprctl keyword monitor "eDP-1,preferred,0x0,1,,,vrr,1"
    notify-send "💻 Laptop screen enabled" "eDP-1 monitor turned on - Triggered using SUPER + F12"
fi
