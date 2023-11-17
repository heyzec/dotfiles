#!/bin/sh
hyprctl keyword decoration:blur:xray $(hyprctl getoption decoration:blur:xray | awk '/int:/ {print !$2}')

