# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:
{
  environment.sessionVariables = {
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";

    TERMINAL        = "foot";
    # Hint electron apps to use wayland
    # BREAKS VSCODE
    
    # "enable Ozone Wayland support in Chromium and Electron based applications
    NIXOS_OZONE_WL = "1";
  };

  programs = {
    dconf.enable = true;
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
    # Enable swtpm, a TPM emulator, needed by Windows 11 VMs
    libvirtd.qemu.swtpm.enable = true;
  };

  documentation.dev.enable = true;

  environment.systemPackages = with pkgs; [
    obs-studio
    tor-browser-bundle-bin

    wl-color-picker
    localsend
    swtpm
    naps2
    iptables
    ipset
    crowdsec
  ];
  
  # systemd.services = {
  #   "syncthing" = {
  #     serviceConfig = {
  #       UMask = "0777";
  #     };
  #   };
  # };
  programs.appimage.binfmt = true;
  boot.tmp.cleanOnBoot = true;
  nix.settings.trusted-users = [ "heyzec" ];  # https://github.com/NixOS/nix/issues/2127#issuecomment-1465191608

  programs.zsh.enable = true;
  heyzec.shell.enable = true;

}

