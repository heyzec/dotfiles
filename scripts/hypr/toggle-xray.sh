#!/bin/sh
hyprctl keyword decoration:blur_xray $(hyprctl getoption decoration:blur_xray | awk '/int:/ {print !$2}')

