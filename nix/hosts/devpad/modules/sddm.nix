{pkgs, ...}: let
  theme = pkgs.sddm-astronaut.override {
    themeConfig = {};
    embeddedTheme = "jake_the_dog";
  };
in {
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services = {
    displayManager.sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm; # Use Qt6 SDDM (default is still Qt5)
      theme = "sddm-astronaut-theme";
      extraPackages = [theme]; # Propagate dependencies, e.g. QtMultimedia, to SDDM
    };
  };
  environment.systemPackages = [theme]; # Make theme available at /run/current-system/sw/share/sddm/themes

  # Add fonts required by our chosen theme
  fonts.fontconfig.localConf = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <dir>/run/current-system/sw/share/sddm/themes/sddm-astronaut-theme/Fonts</dir>
    </fontconfig>
  '';
}
