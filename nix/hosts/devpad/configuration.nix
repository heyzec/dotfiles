# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  inputs,
  pkgs,
  hasPrivate,
  ...
}: {
  imports =
    [
      ./hardware
      ./modules
    ]
    ++ (
      if hasPrivate
      then [
        inputs.private.devpad.modules
        inputs.private.devpad.secrets
      ]
      else []
    );

  programs = {
    dconf.enable = true;
  };

  virtualisation = {
    libvirtd.enable = true;
  };

  # Add additional documentations
  documentation.dev.enable = true; # Targeted at developers
  environment.systemPackages = with pkgs; [
    man-pages #     # Linux man pages
    man-pages-posix # POSIX man pages
  ];

  # NixOS System Version (Do not touch!!)
  system.stateVersion = "23.05";
}
