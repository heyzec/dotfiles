#!/bin/sh
# Change to get wallpaper?, so swaybg is within hyprland?
swaybg --image "$HOME/Pictures/Wallpapers/wallpaper" --mode fill
# This is blocking!!!!
flavours generate dark ~/Pictures/Wallpapers/wallpaper
flavours apply generated
