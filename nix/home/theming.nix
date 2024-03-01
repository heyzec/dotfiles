{ config, pkgs, ... }:
{
  # home.file.colortest = {
  #   text = ''
  #     ${colorScheme.palette.base01}
  #     ${colorScheme.palette.base02}
  #     ${colorScheme.palette.base03}
  #     ${colorScheme.palette.base04}
  #     ${colorScheme.palette.base05}
  #     ${colorScheme.palette.base06}
  #     ${colorScheme.palette.base07}
  #     ${colorScheme.palette.base08}
  #     ${colorScheme.palette.base09}
  #     ${colorScheme.palette.base0A}
  #     ${colorScheme.palette.base0B}
  #     ${colorScheme.palette.base0C}
  #     ${colorScheme.palette.base0D}
  #     ${colorScheme.palette.base0E}
  #     ${colorScheme.palette.base0F}
  #   '';
  #   target = "colortest";
  # };



  # https://wiki.archlinux.org/title/GTK

  gtk.theme = {
    name = "Materia-light";
  };
  gtk.iconTheme = {
    # # https://github.com/vinceliuice/vimix-icon-theme
    # name = "Vimix-Black";

    name = "Vimix-Black";
    package = pkgs.vimix-gtk-themes;


  };
  # Cursors
  # gtk.cursorTheme = {
  #   # https://github.com/vinceliuice/vimix-icon-theme
  #   name = "capitaine-cursors";
  #   package = pkgs.capitaine-cursors;
  # };
  # # https://www.gnome-look.org/browse?cat=107&ord=latest

  qt.enable = true;
  qt.style.name = "adwaita";
}

