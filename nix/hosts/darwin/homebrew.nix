# Install via homebrew when packages are not available on nixpkgs
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    brews = [ ];

    # Update these applications manually.
    # As brew would update them by uninstalling and installing the newest
    # version, it could lead to data loss.
    casks = [
      "docker" # Docker Desktop
      "arc"
    ];

    taps = [ ];
  };
}
