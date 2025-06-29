# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  pkgs,
  ...
}: {
  imports =
    [
      ./hardware
      ./modules
    ]
    ++ (
      if inputs.private.hasPrivate
      then [
        inputs.private.devpad.modules
        inputs.private.devpad.secrets
      ]
      else []
    );

  # Some people put this in .zprofile
  environment.sessionVariables = {
    # Follow XDG Base Directory specification
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    # Default programs
    TERMINAL = "foot";
    BROWSER = "firefox";

    # Offenders: Not fully XDG
    PYTHON_HISTORY = "$XDG_CACHE_HOME/python_history";
  };
  /*
    export GOPATH="$XDG_DATA_HOME"/go, export GOMODCACHE="$XDG_CACHE_HOME"/go/mod
  See how to get rid of .npm, .npmrc
  export _Z_DATA="$XDG_DATA_HOME/z"
  */

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
