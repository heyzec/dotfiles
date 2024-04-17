# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:
let
in {


  services.fprintd.enable = true;

  services.fprintd.tod.enable = true;

  security.pam.services.login.fprintAuth = false;


}

