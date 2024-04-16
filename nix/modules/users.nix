{ pkgs, userSettings, ... }: {
################################################################################
##### User Accounts
################################################################################
  users.mutableUsers = false;
  users.users.${userSettings.username} = {
    isNormalUser = true;
    uid = 1000;
    description = "Main user of this device";
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
    hashedPassword = (import ./users.crypt.nix).hashedPassword;
  };
}
