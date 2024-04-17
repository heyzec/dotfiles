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
    };
  };
}

