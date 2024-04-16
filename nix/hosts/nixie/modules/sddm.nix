{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    displayManager.sddm = {
      enable = true;
      theme = "${import ../../../packages/sddm-theme/sddm-theme.nix { inherit pkgs; }}";
    };
  };
  environment.systemPackages = with pkgs; [
    # The sugar-dark theme requires these dependencies:
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
  ];
}

