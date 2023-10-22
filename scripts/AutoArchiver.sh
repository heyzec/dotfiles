#!/usr/bin/env bash
# AUTOARCHIVER
# Automatically archives files in folder. Sorts them into folders by months. Great for the Downloads folder.

# Requires cronjob to run this script on every @reboot. Example:
# @reboot /path/to/AutoArchiver.sh ~/Downloads
# @reboot /path/to/AutoArchiver.sh ~/Pictures/Screenshots


cd "$1"

folder="Archived/$(date +'%Y-%m')"
mkdir "$folder" 2>/dev/null

find -maxdepth 1 -mindepth 1 \
	! -name 'Archived' \
	-ctime +1 \
	-exec mv "{}" "$folder/" \;
