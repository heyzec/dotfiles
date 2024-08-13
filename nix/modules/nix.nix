{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix = {
    # Refer to man nix.conf for setting explainations
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true; # hard links duplicate files
      connect-timeout = 10; # the default of 300 is too large
      tarball-ttl = 604800; # refresh tarballs once a week instead of every hour
      warn-dirty = false; # don't warn about dirty git trees
    };
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

