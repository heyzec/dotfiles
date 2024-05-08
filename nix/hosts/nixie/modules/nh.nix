{ userSettings, ... }:
{
  # Wrapper around common nix comands
  programs.nh = {
    enable = true;
    flake = userSettings.flakeDir;
  };
}
