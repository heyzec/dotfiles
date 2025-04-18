# dotsmanv3

`dotsman` is a script to help with installing and editing dotfiles!
- Install config files in this repo by symlinking
- Quickly edit config files using any dmenu-compatible program

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


3. To use dmenu or a similar application to quickly select a config to edit, menu, run `dotsman rofi <dmenu-compatible program> [args...]`.
It's recommended to bind this command to a key in your window manager or hotkey daemon for quick access.

    Example 1: [Hyprland](https://github.com/hyprwm/Hyprland) + [rofi](https://github.com/davatorium/rofi):
    ```text
    bind = SUPER, b, exec, dotsman.sh dmenu rofi -dmenu
    ```
    Example 2: [swhkd](https://github.com/waycrate/swhkd) + [walker](https://github.com/abenz1267/walker):
    ```text
    super + o
        dotsman.sh dmenu walker --dmenu --keepsort --placeholder "Select config:"
    ```
