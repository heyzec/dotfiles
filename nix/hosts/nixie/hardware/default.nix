{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./bootloader.nix
    ./bluetooth.nix
    ./hardware-configuration.nix
    ./networking.nix
  ];
}
