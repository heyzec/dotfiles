{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
      enable = true;
      xdgOpenUsePortal = false;
      extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          # is a fork of hyprland
          xdg-desktop-portal-gtk
          xdg-desktop-portal-hyprland
      ];
      wlr.enable = true;
  };
}
