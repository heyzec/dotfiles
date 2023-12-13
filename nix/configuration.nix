# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:
let
in {

  nixpkgs.config.allowUnfree = true;

# 1. HARDWARE, BOOT, NETWORK SETTINGS {{{
################################################################################
##### Hardware settings
################################################################################



  environment.sessionVariables = {
    XDG_CACHE_HOME  = "$HOME/.cache";
    # XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";
    TERMINAL        = "foot";
    # Hint electron apps to use wayland
    # BREAKS VSCODE
    # NIXOS_OZONE_WL = "1";
  };
# }}}

# 3. CONFIGURED PROGRAMS {{{
################################################################################
##### Programs
################################################################################
  programs = {
    nix-ld.enable = true;
    dconf.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
    };

    zsh = {
      enable = true;
    };

    firefox = {
      enable = true;
      nativeMessagingHosts.packages = [ pkgs.tridactyl-native ];
    };


    # xfce.thunar                # file manager
    # xfce.thunar-volman         # volume manager integration for thunar
    # xfce.thunar-archive-plugin # integration with archive tool - file-roller
    # xfce.tumbler               # generate thumbnails

    wireshark.enable = true;
    wireshark.package = pkgs.wireshark;

  };

  environment.etc."asdf-vm/asdf.sh".source = "${pkgs.asdf-vm}/share/asdf-vm/asdf.sh";
# }}}

# 5. SERVICES AND SYSTEMD {{{
################################################################################
##### Services and SystemD
################################################################################
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

    # tumbler.enable = true; # Thumbnail support for images

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

# }}}

# 6. OTHERS {{{


  xdg.mime.enable = true;



  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.policykit.exec" &&
            action.lookup("program") == "/run/current-system/sw/bin/swhkd") {
                return polkit.Result.YES;
        }
    });
  '';

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  documentation.dev.enable = true;



 # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;




# }}}
programs.gnupg.agent = {
   enable = true;
   pinentryFlavor = "curses";
};

  environment.systemPackages = with pkgs; [
    pinentry-curses
    git-crypt
    cryptsetup
    ollama
  ];

  # environment.etc.crypttab = {
  #   enable = true;
  #   text = ''
  #     private /dev/nvme0n1p12 none luks,noauto
  #   '';
  # };
  programs.ssh.startAgent = true;

}

