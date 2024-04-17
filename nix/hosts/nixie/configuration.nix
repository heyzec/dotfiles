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



# 6. OTHERS {{{


  xdg.mime.enable = true;



  security = {
    polkit.enable = true;
  };



  services.fprintd.enable = true;

  services.fprintd.tod.enable = true;

  security.pam.services.login.fprintAuth = false;
  security.pam.services.swaylock.fprintAuth = false;

  # Enroll properly
  # https://discourse.nixos.org/t/nixos-unstable-fprintd-fingerprint-reader-issues/33273/2
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

}

