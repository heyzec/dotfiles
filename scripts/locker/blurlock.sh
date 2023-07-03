#!/usr/bin/env bash

icon="$HOME/dotfiles/scripts/locker/icon.png"

swaylock --daemonize \
    --screenshots --effect-blur 10x2 --effect-compose "$icon" \
    --indicator-radius 100 --inside-color 00000050 \
    --line-ver-color 00000000 --line-wrong-color 00000000 \
    --grace 3 \
    --fade-in 0.5 \
    --show-failed-attempts --ignore-empty-password

