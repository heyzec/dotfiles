#!/usr/bin/env python3

# Inspired by https://gitlab.com/matclab/rofi-i3-shortcut-help
import re
import os
from html import escape


CONFIG = os.environ.get("HOME") + "/.config/sway/config"

configs = [
    "/dotfiles/desktop/swhkd/swhkdrc",
    "/dotfiles/desktop/hyprland/hyprland.conf",
]

print("\0markup-rows\x1ftrue\n")


for file in configs:
    filename = os.environ.get("HOME") + file
    with open(filename) as f:
        for line in f.readlines():
            regex = re.compile(r"\s*## (?P<category>.+) // (?P<action>.+) // (?P<keybinding>.+) ##")
            matches = regex.match(line)
            if matches is not None:
                category = matches.group("category")
                action = matches.group("action")
                keybinding = matches.group("keybinding")
                keybinding = escape(keybinding)
                print(f"""<b>{action:<20}</b>\t<span foreground="grey">{category}</span>\t<tt>{keybinding}</tt>""")
