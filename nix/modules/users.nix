{ config, pkgs, inputs, ... }: {
################################################################################
##### User Accounts
################################################################################
  users.mutableUsers = false;
  users.users.heyzec = {
    isNormalUser = true;
    uid = 1000;
    description = "heyzec";
    extraGroups = [
      "wheel"            # Access sudo command
      "networkmanager"   # Access network manager
      "uinput"
      "input"
      "video"
      "docker"
      "libvirtd"
      "plocate"
      "ic2"              # Control /dev/i2c-* devices
      "wireshark"
    ];
    shell = pkgs.zsh;
    hashedPassword = import ../secrets/hashed-password.nix;
  };
}
