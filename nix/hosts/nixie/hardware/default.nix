{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./bootloader.nix
    ./hardware-configuration.nix
  ];
}
