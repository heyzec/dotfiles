################################################################################
##### Nix Configuration
################################################################################
{ pkgs, userSettings, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.auto-optimise-store = true;  # hard links duplicate files
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Wrapper around common nix comands
  programs.nh = {
    enable = true;
    flake = userSettings.flakeDir;
  };

  environment.systemPackages = with pkgs; [
    comma      # Run software without installing
  ];

  # NixOS System Version (Do not touch!!)
  system.stateVersion = "23.05";
}

