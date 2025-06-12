# Taken from https://github.com/donovanglover/nix-config, someting in this file is needed
# for it to be possible to nixos-buildvm and for vm generated to not crash on Hyprland
{ lib, pkgs, userSettings, ... }:
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
        dotfiles = if builtins.substring 0 1 userSettings.dotfilesDir == "~"
          then {
            # Apply sane intepretation of path with ~
            source = builtins.replaceStrings ["~"] ["$HOME"] userSettings.dotfilesDir;
            target = "/home/${userSettings.username}/" +
              builtins.replaceStrings ["~"] ["."] userSettings.dotfilesDir;
          } else {
            # Treat dotfilesDir as absolute path and try
            source = userSettings.dotfilesDir;
            target = userSettings.dotfilesDir;
          };
      };
    };

    virtualisation.qemu.options = [
      # "-device virtio-vga-gl"
      # "-display sdl,gl=on,show-cursor=off"
      "-device virtio-vga-gl"
      "-device usb-tablet"
      "-display gtk,gl=on,show-cursor=off"
      "-audio pa,model=hda"
    ];

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    services.interception-tools.enable = lib.mkForce false;

    environment.systemPackages = with pkgs; [
      kitty  # For bare hyprland to be usable
      home-manager
    ];
  };
}
