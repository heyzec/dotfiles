{ pkgs, ... }:
{
  # Use inline modules to merge home.packages automatically
  imports = [
    #############################################################
    # Toolkit theming
    #############################################################
    {
      home.packages = with pkgs; [
        flavours
      ];

      # https://wiki.archlinux.org/title/GTK
      gtk = {
        theme = {
          name = "Materia-light";
        };
        iconTheme = {
          # https://github.com/vinceliuice/vimix-icon-theme
          name = "Vimix-Black";
          package = pkgs.vimix-icon-theme;
        };
      };

      qt.enable = true;
      qt.style.name = "adwaita";
    }
    #############################################################
    # Cursors
    #############################################################
    (let
      cursorName = "Bibata-Modern-Ice";
      cursorSize = 20;
    in {
      home.pointerCursor = {
        # General config
        package = pkgs.bibata-cursors;
        name = cursorName;
        size = cursorSize;
        # Enable config generation for specific backends
        gtk.enable = true;
      };

      xdg.configFile."hypr/nix.conf" = {
        text = /* conf */ ''
          exec-once = hyprctl setcursor ${cursorName} ${builtins.toString cursorSize}
        '';
      };
    })
  ];
}
