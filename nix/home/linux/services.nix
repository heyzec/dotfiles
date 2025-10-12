{pkgs, ...}: {
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 10000;
      # base01 is also waybar's background color
      # backgroundColor = "#${config.colorScheme.palette.base01}";
      # borderColor = "#${config.colorScheme.palette.base0E}";
      # textColor = "#${config.colorScheme.palette.base04}";
      background-color = "#3e4954";
      border-color = "#d3869b";
      text-color = "#bdae93";
      border-radius = 5;
      border-size = 2;
    };
  };

  # Not sure why waybar doesn't start when managed by home-manager, use NixOS isntead
  # programs.waybar.enable = true;

  # nm-applet provides auth dialogs to manage wired and wireless networks
  services.network-manager-applet.enable = true;

  systemd.user.services.indicator-sound-switcher = {
    Unit = {
      Description = "Sound input/output tray applet";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.indicator-sound-switcher}/bin/indicator-sound-switcher";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  # Volume and display brightness indicator
  services.wob.enable = true;

  # There are many wallpaper setters, but hyprpaper is the only one with a configurable HM module
  services.hyprpaper = let
    image = "$HOME/Pictures/Wallpapers/wallpaper";
  in {
    enable = true;
    settings = {
      preload = [image];
      wallpaper = [",${image}"];
    };
  };

  services.hypridle.enable = true;

  # See https://wiki.hyprland.org/Useful-Utilities/Clipboard-Managers/
  services.cliphist = {
    enable = true;
    allowImages = true;
  };
  systemd.user.services.wl-clip-persist = {
    Unit = {
      Description = "Keep Wayland clipboard even after programs close";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "simple";
      # Don't use primary keyboard, only regular
      # https://github.com/Linus789/wl-clip-persist/issues/3
      ExecStart = "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
