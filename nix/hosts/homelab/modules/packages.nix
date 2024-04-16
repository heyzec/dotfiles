{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    libraspberrypi # tools to interface with raspberry pi hardware
    raspberrypi-eeprom

    wget
    docker
    python311
    restic

    plocate
    go
    gnumake
    tmux

    btop
    btdu
    neovim
    lf
    git # needed by nvim
  ];
}

