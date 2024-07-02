# For package that are not available on nixpkgs
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    brews = [ ];

    # Update these applicatons manually.
    # As brew would update them by unninstalling and installing the newest
    # version, it could lead to data loss.
    casks = [
      "docker" # Docker Desktop
      "arc"
    ];

    taps = [
      # "railwaycat/emacsmacport" # emacs-mac
    ];

    # masApps = {
    #   Tailscale = 1475387142; # App Store URL id
    # };
  };
}
