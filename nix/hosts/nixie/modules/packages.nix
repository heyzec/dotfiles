{ config, pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    ################################################################################
    ##### Command-line Utilities
    ################################################################################

    ##### Command line utilities: Basics #####
    git
    gnupg
    wget
    zip unzip
    tmux
    git-crypt

    ##### Command line utilities: Hardware drivers related #####
    bluez               # bluetooth related commands (e.g. bluetoothctl)

    ##### Command line utilities: Terminal #####
    lf                  # terminal file manager
    neofetch            # terminal system info display
    nix-output-monitor  # prettify nix command outputs

    ##### Command line utilities: System #####
    btop                # better top

    ##### Graphical environment
    foot                   # terminal emulator
    hypridle               # idle management daemon
    swaybg                 # wallpaper setter for wayland
    swaylock-effects       # screen locker for sway
    # wlogout                # logout menu

  ];
}
