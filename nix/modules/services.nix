################################################################################
##### Services and SystemD
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
    };

    #    udev.extraRules = ''
    #        KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
    #  '';

    auto-cpufreq.enable = true;

    earlyoom = {
      enable = true;
      extraArgs = [
        "--avoid '^(Hyprland)$'"
          "--prefer '^(electron)$'"
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

    locate = {
      enable = true;
      package = pkgs.plocate;
      localuser = null;  # to squelch warning: plocate does not support non-root updatedb
        pruneNames = [
        ".bzr" ".cache" ".git" ".hg" ".svn"  # defaults
          "node_modules"
        ];
      prunePaths = [
        "/mnt/D"
          "/media/D"
      ];
    };

    # Enable the OpenSSH daemon.
    openssh.enable = true;

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

