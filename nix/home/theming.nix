{ config, pkgs, ... }:
{
  # home.file.colortest = {
  #   text = ''
  #     ${colorScheme.colors.base01}
  #     ${colorScheme.colors.base02}
  #     ${colorScheme.colors.base03}
  #     ${colorScheme.colors.base04}
  #     ${colorScheme.colors.base05}
  #     ${colorScheme.colors.base06}
  #     ${colorScheme.colors.base07}
  #     ${colorScheme.colors.base08}
  #     ${colorScheme.colors.base09}
  #     ${colorScheme.colors.base0A}
  #     ${colorScheme.colors.base0B}
  #     ${colorScheme.colors.base0C}
  #     ${colorScheme.colors.base0D}
  #     ${colorScheme.colors.base0E}
  #     ${colorScheme.colors.base0F}
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

