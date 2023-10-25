{ pkgs, ... }:

{
  programs.thunar = {
    enable = true;               # file manager
    plugins = with pkgs.xfce; [
      thunar-archive-plugin             # integration with archive tool - file-roller
      thunar-volman                     # volume manager integration for thunar
      tumbler               # generate thumbnails
    ];
  };

  programs.file-roller.enable = true;
}
