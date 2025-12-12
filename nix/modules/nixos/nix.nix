{
  pkgs,
  inputs,
  self,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  nix = {
    # Refer to man nix.conf for setting explainations
    settings = {
      experimental-features = ["nix-command" "flakes"];
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

  # Disable the global registry (otherwise defaults to https://github.com/NixOS/flake-registry)
  nix.settings.flake-registry = "";

  # Create a "nixpkgs" entry in the system registry, pinned to our flake nixpkgs input
  nix.registry = {
    nixpkgs = {
      flake = inputs.nixpkgs;
    };
  };

  environment.systemPackages = with pkgs; [
    git-crypt #        # Needed to decrypt our dotfiles repo
    comma #            # Run software without installing
    nix-output-monitor # prettify nix command outputs
  ];

  system.nixos.label =
    if self.sourceInfo ? lastModifiedDate && self.sourceInfo ? shortRev
    then "${inputs.nixpkgs.lib.substring 0 8 self.sourceInfo.lastModifiedDate}.${self.sourceInfo.shortRev}"
    else inputs.nixpkgs.lib.warn "Repo is dirty, revision will not be available in system label" "dirty";
}
