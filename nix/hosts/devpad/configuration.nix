# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: {
  imports = [
    ./hardware
    ./modules
  ];

  environment.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    TERMINAL = "foot";
  };

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
}
