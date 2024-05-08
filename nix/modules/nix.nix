{ pkgs, ... }:
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

  environment.systemPackages = with pkgs; [
    comma      # Run software without installing
  ];

  # NixOS System Version (Do not touch!!)
  system.stateVersion = "23.05";
}

