#!/bin/bash

WALLDIR="$HOME/Pictures/wallpapers/"

choice=$(find "$WALLDIR" -maxdepth 1 -type f -printf "%f\n" \
  | rofi -dmenu -p "Wallpaper")

[ -z "$choice" ] && exit 0

wpg -ns "$WALLDIR/$choice"
killall quickshell && quickshell &

awww img "$WALLDIR/$choice" \
  --transition-type grow \
  --transition-pos 0.5,0.5 \
  --transition-duration 1 \
  --transition-fps 60
