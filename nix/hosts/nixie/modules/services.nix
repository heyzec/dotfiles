################################################################################
##### Services
################################################################################
{ pkgs, ... }:
{
  services = {
    dbus = {
      enable = true;
      packages = [ pkgs.flameshot ];
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber = {
        enable = true;
        # Workaround for battery drain caused by pipewire and webcam
        # https://www.reddit.com/r/linux/comments/1em8biv/psa_pipewire_has_been_halving_your_battery_life/
        extraConfig.fix = {
          "wireplumber.profiles" = {
            "main" = {
              "monitor.libcamera" = "disabled";
            };
          };
        };
      };
    };

    #    udev.extraRules = ''
    #        KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
    #  '';

    auto-cpufreq.enable = true;

    earlyoom = {
      enable = true;
      extraArgs = [
        "--avoid"
        "^(Hyprland)$"
        "--prefer"
        "^(electron)$"
      ];
    };

    flatpak = {
      enable = true;
    };

    # For automounting
    devmon.enable = true;
    gvfs.enable = true; # Mount, trash, and other functionalities
      udisks2.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
    };

    cron.enable = true;  # Temporary, until we migrate all to systemd timers

    thermald.enable = true;
  };


  systemd = {
    user.services.kanshi = {
      description = "kanshi daemon a";
      serviceConfig = {
        Type = "simple";
        ExecStart = ''${pkgs.kanshi}/bin/kanshi'';
      };
    };
  };
}

