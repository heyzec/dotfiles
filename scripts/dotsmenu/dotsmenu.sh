#!/usr/bin/env bash

ITEMS_FILE=$HOME/.config/sway/scripts/dotsmenu/items

config_names=$(awk '{print $1}' "$ITEMS_FILE")

selected_config_name=$( (echo "$config_names") | rofi -dmenu -p "Select config file")
if [ -z "$selected_config_name" ]; then
    exit
fi
selected_config_file=$(awk '/^'"$selected_config_name"'/{print $2}' "$ITEMS_FILE")
selected_config_file_expanded=$(envsubst <<< "$selected_config_file")
if [ -z "$selected_config_file_expanded" ]; then
    notify-send "dotsmenu" "No valid entry selected!"
    exit
fi

if [[ -e $selected_config_file_expanded ]]; then
    rofi-sensible-terminal -e "$EDITOR" "$(envsubst <<< "$selected_config_file_expanded")"
else
    notify-send "dotsmenu" "Path to $selected_config_name ($selected_config_file_expanded) does not exist!"
fi
