{
  services = {
    xserver.enable = true;
    xserver.desktopManager.plasma5.enable = true;
    xserver.desktopManager.plasma5.bigscreen.enable = true;
    xserver.displayManager.sddm.enable = true;
    xserver.displayManager.sddm.settings = {
      Autologin = {
        Session = "plasma-bigscreen-x11.desktop";
        User = "pi";
      };
    };
  };
}

