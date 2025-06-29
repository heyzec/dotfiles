{
  pkgs,
  lib,
  ...
}: {
  programs.niri.enable = true;
  services.gnome.gnome-keyring.enable = lib.mkDefault false; # Don't implicitly enable gnome-keyring

  programs.hyprland = {
    withUWSM = true; # Otherwise, we will not reach graphical-session.target
    enable = true;
    xwayland.enable = true;
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
