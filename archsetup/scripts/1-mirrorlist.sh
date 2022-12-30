#!/bin/bash

info Syncing package databases
pacman -Syu --noconfirm
pacman -S --noconfirm archlinux-keyring #update keyrings to latest to prevent packages failing to install
pacman -S pacman-contrib --noconfirm --needed
pacman -S --noconfirm --needed curl
# 1.2. Setup mirrors for opitmal download
iso=$(curl -4 ifconfig.co/country-iso)
info Setting up $iso mirrors for faster downloads
curl -s "https://archlinux.org/mirrorlist/?country=SG&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - > /etc/pacman.d/mirrorlist
info Done setting up mirrors
