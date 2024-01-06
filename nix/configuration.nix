# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:
let
in {


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

    wireshark.enable = true;
    wireshark.package = pkgs.wireshark;

  };

  environment.etc."asdf-vm/asdf.sh".source = "${pkgs.asdf-vm}/share/asdf-vm/asdf.sh";
# }}}


# 6. OTHERS {{{


  xdg.mime.enable = true;



  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
  };


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
    cryptsetup
    ollama
    obs-studio
    tor-browser-bundle-bin

    wl-color-picker


    (floorp.override {
      nativeMessagingHosts = with pkgs; [
        tridactyl-native
      ];
    })
  ];

  programs.ssh.startAgent = true;

  programs.adb.enable = true;
  users.users.heyzec.extraGroups = [ "adbusers" ];
}

