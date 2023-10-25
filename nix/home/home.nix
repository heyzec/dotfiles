# See https://rycee.gitlab.io/home-manager/options.html
{
  # We're using the "Standalone installation" option, let home-manager install itself
  programs.home-manager.enable = true;

  home.stateVersion = "23.05";
  home.username = "heyzec";
  home.homeDirectory = "/home/heyzec";

  # https://github.com/nix-community/home-manager/issues/1011
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP="Hyprland";
    XDG_SESSION_TYPE="wayland";
    TERMINAL = "foot";
  };
}

