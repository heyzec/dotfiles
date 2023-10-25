# Taken from https://github.com/donovanglover/nix-config, someting in this file is needed
# for it to be possible to nixos-buildvm and for vm generated to not crash on Hyprland
{ lib, pkgs, ... }:

{
  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 8192;
      cores = 4;

      sharedDirectories = {
        home = {
          source = "$HOME";
          target = "/mnt";
        };
        dotfiles = {
          source = "$HOME/dotfiles";
          target = "/home/heyzec/dotfiles";
        };
        nix = {
          source = "$HOME/nix";
          target = "/home/heyzec/nix";
        };
      };
    };

    virtualisation.qemu.options = [
      "-device virtio-vga-gl"
      "-display sdl,gl=on,show-cursor=off"
      "-audio pa,model=hda"
    ];

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    services.interception-tools.enable = lib.mkForce false;

    environment.systemPackages = [
      pkgs.kitty  # For bare hyprland to be usable
      pkgs.home-manager
    ];
  };
}
