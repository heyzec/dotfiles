################################################################################
##### Boot Settings
################################################################################
{ pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.kernelPackages = pkgs.stable.linuxPackages;
  boot.kernelParams = [
    "\"PARTLABEL=Swap partition\""
    # https://wiki.archlinux.org/title/intel_graphics#Crash/freeze_on_low_power_Intel_CPUs
    # Disable GPU power management to fix random hangs
    "i915.enable_dc=0"
  ];
  # Enable all sysrq functions (useful to recover from some issues):
  boot.kernel.sysctl."kernel.sysrq" = 1; # NixOS default: 16 (only the sync command)

  # To cross-compile
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  # Enable boot splash
  boot.plymouth.enable = true;

  boot.initrd.kernelModules = [
    # Early KMS for plymouth to start earlier
    # https://wiki.archlinux.org/title/Kernel_mode_setting#Early_KMS_start
    "i915"
  ];

  # From hardware-configuration.nix
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
}
