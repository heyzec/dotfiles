# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:
{
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
  ];
  
  services.syncthing = {
    enable = true;
    user = "heyzec";
    group = "users";
    dataDir = "/home/heyzec";
    configDir = "/home/heyzec/.config/syncthing";
    settings = {
      overrideDevices = true;
      overrideFolders = true;
      devices = {
        "S20FE" = { id = "CMS62ZT-RSXEEHA-XM7YQ64-QC3425Q-DA3KGBS-W6OAZNN-SV2PD6U-NWBP7AX"; };
      };
      folders = {
        "Obsidian" = {
          id = "vault";
          path = "/home/heyzec/Documents/Vault";
          devices = [ "S20FE" ];
        };
      };
    };
  };
  # systemd.services = {
  #   "syncthing" = {
  #     serviceConfig = {
  #       UMask = "0777";
  #     };
  #   };
  # };


}

