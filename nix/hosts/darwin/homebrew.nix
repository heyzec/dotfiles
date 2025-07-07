# Install via homebrew when packages are not available on nixpkgs
{inputs, ...}: {
  # Install homebrew with nix-homebrew because of the following issue:
  # https://github.com/nix-darwin/nix-darwin/issues/884
  imports = [inputs.nix-homebrew.darwinModules.nix-homebrew];
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "SP15013";
  };

  # Use nix-darwin's homebrew module to declaratively install
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    brews = [];
    # Update these applications manually.
    # As brew would update them by uninstalling and installing the newest
    # version, it could lead to data loss.
    casks = [
      "docker" # Docker Desktop
      "arc"
    ];
    taps = [];
  };
}
