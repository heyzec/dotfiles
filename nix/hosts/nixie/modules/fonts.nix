# System-wide fonts, prefer setting fonts in home-manager
{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      roboto             # Google's sans-serif fonts
      roboto-mono        # Google's sans-serif monospace font
      vistafonts
    ];
  };
}
