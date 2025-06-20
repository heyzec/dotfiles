################################################################################
##### Services
################################################################################
{pkgs, ...}: {
  services = {
    dbus = {
      enable = true;
      packages = [pkgs.flameshot];
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

    avahi = {
      enable = true;
      nssmdns4 = true;
    };

    cron.enable = true; # Temporary, until we migrate all to systemd timers

    thermald.enable = true;
  };
}
