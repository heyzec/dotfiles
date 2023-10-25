{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./boot.nix
    ./dell-9310.nix
    ./filesystems.nix
    ./hardware.nix
    ./networking.nix
  ];
}
