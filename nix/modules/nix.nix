{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.auto-optimise-store = true; # hard links duplicate files
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Run dynamically linked executables on NixOS
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    git-crypt #        # Needed to decrypt our dotfiles repo
    comma #            # Run software without installing
    nix-output-monitor # prettify nix command outputs

  ];

  # NixOS System Version (Do not touch!!)
  system.stateVersion = "23.05";
}

