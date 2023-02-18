#!/usr/bin/env python3

# Inspired by https://gitlab.com/matclab/rofi-i3-shortcut-help
import re
import os
from html import escape


CONFIG = os.environ.get("HOME") + "/.config/sway/config"

print("\0markup-rows\x1ftrue\n")


with open(CONFIG) as f:
    for line in f.readlines():
        regex = re.compile(r"\s*## (?P<category>.+) // (?P<action>.+) // (?P<keybinding>.+) ##")
        matches = regex.match(line)
        if matches is not None:
            category = matches.group("category")
            action = matches.group("action")
            keybinding = matches.group("keybinding")
            keybinding = escape(keybinding)
            print(f"""<b>{action:<20}</b>\t<span foreground="grey">{category}</span>\t<tt>{keybinding}</tt>""")
