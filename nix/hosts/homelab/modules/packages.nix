{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    libraspberrypi # tools to interface with raspberry pi hardware
    raspberrypi-eeprom

    docker
    python311
    restic

    plocate
    go
    gnumake

    btop
    btdu
  ];
}

