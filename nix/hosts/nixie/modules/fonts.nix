################################################################################
##### Fonts
################################################################################
{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      roboto             # Google's sans-serif fonts
      roboto-mono        # Google's sans-serif monospace font
      noto-fonts         # Google's fonts
      noto-fonts-emoji   # Google's open-source Emoji 14.0

      # Only install a selection of fonts from nerdfonts repository
      (nerdfonts.override { fonts = [ "RobotoMono" ]; })
    ];
    fontconfig.enable = true;
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [ "Noto Sans" ];
      monospace = [ "Noto Sans Mono" ];
      # also set monospace and emoji
    };
  };
}
