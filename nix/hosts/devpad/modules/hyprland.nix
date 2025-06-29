{pkgs, ...}: {
  # Refer to home-manager for entry-point to configurations
  programs.niri.enable = true;
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
