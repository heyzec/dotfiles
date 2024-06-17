{ pkgs, ... }: let
  imgLink = "https://wallpaperaccess.com/full/674253.png";

  image = pkgs.fetchurl {
    url = imgLink;
    sha256 = "sha256-SLEh6PSkBxsPAzkJyUTaVGFVh51wqI9zJN7ekGZLrfU=";
  };
in
{
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.displayManager.sddm = {
    enable = true;
    theme = "sugar-dark";
  };

  environment.systemPackages = with pkgs; [
    (sddm-sugar-dark.override {
      themeConfig = {
        Background = image;
      };
    })
  ];
}

