# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ lib, ... }:

{
  security.polkit.enable = true;

  nix.settings.trusted-users = [ "pi" ];  # https://github.com/NixOS/nix/issues/2127#issuecomment-1465191608

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  services.caddy.enable = true;
  services.caddy.extraConfig = ''
    heyzec.dedyn.io

    reverse_proxy * localhost:8123
  '';

  services.fail2ban.enable = true;
}

