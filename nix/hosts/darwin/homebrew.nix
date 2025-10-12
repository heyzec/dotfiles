# Install via homebrew when packages are not available on nixpkgs
{
  # Install homebrew with nix-homebrew because of the following issue:
  # https://github.com/nix-darwin/nix-darwin/issues/884
  # EDIT: My experience with nix-homebrew has been buggy, facing:
  # - https://github.com/zhaofengli/nix-homebrew/issues/3
  # - https://github.com/zhaofengli/nix-homebrew/issues/5
  # - https://github.com/zhaofengli/nix-homebrew/issues/105
  # - https://github.com/zhaofengli/nix-homebrew/issues/106

  # Moreover, when nix-darwin activates the profile, the homebrew portion
  # can fail silently, causing remaining of the profile to not activate.
  # As such, install brew and its apps separately instead of via Nix.

  # imports = [inputs.nix-homebrew.darwinModules.nix-homebrew];
  # nix-homebrew = {
  #   enable = true;
  #   user = "<username here>";
  #   taps = {
  #     "homebrew/homebrew-core" = inputs.homebrew-core;
  #     "homebrew/homebrew-cask" = inputs.homebrew-cask;
  #   };
  # };

  # # Use nix-darwin's homebrew module to declaratively install
  # homebrew = {
  #   enable = true;
  #   onActivation = {
  #     autoUpdate = true;
  #     cleanup = "zap";
  #     upgrade = true;
  #   };
  #   brews = [];
  #   # Update these applications manually.
  #   # As brew would update them by uninstalling and installing the newest
  #   # version, it could lead to data loss.
  #   casks = [
  #     "docker" # Docker Desktop
  #     "arc"
  #   ];
  #   taps = builtins.attrNames config.nix-homebrew.taps;
  # };
}
