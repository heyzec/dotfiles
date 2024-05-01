#!/usr/bin/env python3

# Inspired by https://gitlab.com/matclab/rofi-i3-shortcut-help
import re
import os
from html import escape


configs = [
    "$HOME/dotfiles/desktop/swhkd/swhkdrc",
    "$HOME/dotfiles/desktop/hyprland/hyprland.conf",
]
configs = [os.path.expandvars(e) for e in configs]

print("\0markup-rows\x1ftrue\n")

# Format: ## <category> // <action> // <keybinding> ## <reserved for user notes>
regex = re.compile(r".*## (?P<category>.+) // (?P<action>.+) // (?P<keybinding>.+) ##")

for filename in configs:
    with open(filename) as f:
        for line in f.readlines():
            matches = regex.match(line)
            if matches is not None:
                category = matches.group("category")
                action = matches.group("action")
                keybinding = matches.group("keybinding")
                keybinding = escape(keybinding)
                print(f"""<b>{action:<20}</b>\t<span foreground="grey">{category}</span>\t<tt>{keybinding}</tt>""")
