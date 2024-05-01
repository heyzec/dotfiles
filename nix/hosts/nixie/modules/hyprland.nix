{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # Temp fix: do not set XDG_SESSION_TYPE to "wayland"
    # https://github.com/NixOS/nixpkgs/issues/308287
    envVars.enable = false;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = false;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    wlr.enable = true;
  };
}
