#!/usr/bin/env bash

FILE=$HOME/.config/i3/scripts/items

CONFIGS_NAMES=$(awk '{print $1}' $FILE)

SELECTED_CONFIG_NAME=$( (echo "$CONFIGS_NAMES") | rofi -dmenu -p "Select config file")

SELECTED_CONFIG_FILE=$(awk '/'"$SELECTED_CONFIG_NAME"'/{print $2}' $FILE)

SELECTED_CONFIG_FILEPATH=$(envsubst <<< $SELECTED_CONFIG_FILE)

if [[ -e $SELECTED_CONFIG_FILEPATH ]]; then
    rofi-sensible-terminal -e i3-sensible-editor $(envsubst <<< $SELECTED_CONFIG_FILEPATH)
else
    notify-send "Hi" "Could not find $SELECTED_CONFIG_FILEPATH!"
fi
