# User fonts
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    noto-fonts         # Google's fonts
    noto-fonts-emoji   # Google's open-source Emoji 14.0

    jetbrains-mono     # JetBrain's fonts for IDEs

    # Only install a selection of fonts from nerdfonts repository
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
  fonts = {
    fontconfig.enable = true;
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [ "Noto Sans" ];
      monospace = [ "JetBrainsMono Nerd Font" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
