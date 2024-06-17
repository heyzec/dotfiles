{ pkgs, lib, inputs, systemSettings, ... }:
{
  imports = [
    # - Blacklisting psmouse kernel module
    # - Enable fwupd to update firmware via `fwupdmgr`
    # - Enable fstrim
    # - Enable updating of microcode for intel CPU
    inputs.nixos-hardware.nixosModules.dell-xps-13-9310
  ];

  hardware = {
    bluetooth.enable = true;
    bluetooth.settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
    uinput.enable = true;
    i2c.enable = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        libvdpau-va-gl
      ];
    };
  };

  nixpkgs.hostPlatform = systemSettings.system;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
