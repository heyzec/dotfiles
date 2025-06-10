{userSettings, ...}: {
  # Wrapper around common nix commands
  programs.nh = {
    enable = true;
    flake = userSettings.flakeDir;
  };
}
