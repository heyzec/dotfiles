{ config, pkgs, ... }:
let
  cursorName = "Bibata-Modern-Ice";
  cursorSize = 20;
in {
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
  gtk.cursorTheme = {
    name = cursorName;
    package = pkgs.bibata-cursors;
    size = cursorSize;
  };

  xdg.configFile."hypr/nix.conf" = {
    text = /* conf */ ''
      exec-once = hyprctl setcursor ${cursorName} ${builtins.toString cursorSize}
      env = XCURSOR_SIZE,${builtins.toString cursorSize}
      env = XCURSOR_THEME,${cursorName}
    '';
  };


  qt.enable = true;
  qt.style.name = "adwaita";
}

