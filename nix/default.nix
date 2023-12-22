{ config, pkgs, inputs, ... }: {
  imports = [
    ./modules
    ./hardware/laptop
    ./configuration.nix
    # ./overlays/hyprland.nix
    ./overlays/swhkd.nix
  ];
}
