{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    displayManager.sddm = {
      enable = true;
      theme = "${import ../packages/sddm-theme/sddm-theme.nix { inherit pkgs; }}";
    };
  };
}

