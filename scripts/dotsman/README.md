# dotsinstall

Dotsinstall is a script to help with installing config files in this repo by symlinking.

It is written to have as little dependencies as possible - almost nothing!
- `sh` (POSIX-compliant)
- `envsubst` (optional)

## How to use
1. Call the [`dotsinstall.sh`](dotsinstall.sh) script with a program name. The definitions of where each config
will be symlinked to where is defined in [`items.ini`](items.ini).
Example:
```
./dotsinstall.sh nvim
# ln -s -v /home/heyzec/dotfiles/nvim /home/heyzec/.config/nvim
```

