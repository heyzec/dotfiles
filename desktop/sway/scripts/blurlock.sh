#!/usr/bin/env bash
# https://www.reddit.com/r/i3wm/comments/5w95fp/how_to_get_lockscreen_like_this/

icon="$HOME/Pictures/icon.png"

(( $# )) && { icon=$1; }

pkill picom
sleep 0.1
picom -b --blur-kern "11x11gaussian" --blur-background --blur-strength 3 --blur-method dual_kawase --backend glx --experimental-backends
sleep 0.1
xrefresh

i3lock -n -c 00000000 -i "$icon" -C --pass-media-keys --pass-screen-keys --pass-volume-keys
