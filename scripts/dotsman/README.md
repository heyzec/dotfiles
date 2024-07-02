# dotsmanv3

`dotsman` is a script to help with installing and editing dotfiles!
- Install config files in this repo by symlinking
- Quickly edit config files using [rofi](https://github.com/davatorium/rofi)

![Showcase](./showcase.gif)

It is written to have as little dependencies as possible - almost nothing!
- `rofi` (obviously)
- `sh` (POSIX-compliant)
- `envsubst` (optional)

## How to use
1. Fill up the [`items.ini`](items.ini) file, adding a section for each files to appear on the menu. An example:
    ```
    [home-manager]
    file=$HOME/nix/home/home.nix
    posthook=home-manager switch --flake ~/nix/#heyzec --impure |& nom
    ```
    - `file` is the path to the config file, which can include variables.
    - `posthook` is the shell command to run upon editor exiting


2. To install the config file for a program, run `dotsman install <program>`:
    ```
    ./dotsman.sh install nvim
    # ln -s -v /home/heyzec/dotfiles/nvim /home/heyzec/.config/nvim
    ```
    To install all configs, run `dotsman install all`.


3. To open the rofi menu, run `dotsman rofi`.
It would make sense to set a keybind that calls this script in an appropriate place, e.g. window manager

