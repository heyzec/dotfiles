################################################################################
##### Nix Configuration
################################################################################

{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  # NixOS System Version (Do not touch!!)
  system.stateVersion = "23.05";
}

