{userSettings, ...}: {
  users = {
    mutableUsers = false;

    users.${userSettings.username} = {
      isNormalUser = true;
      uid = 1000;
      description = "Main user of this device";

      # See here for a brief explanation of each group
      # https://wiki.archlinux.org/title/Users_and_groups#Group_list
      extraGroups = [
        "wheel" #        # Access sudo command
        "networkmanager" # Access network manager
        "ic2" #          # Control /dev/i2c-* devices
        "wireshark" #    # Capture interfaces without sudo
        "libvirtd"
      ];

      hashedPassword = (import ./users.crypt.nix).hashedPassword;
      openssh.authorizedKeys.keys = (import ./users.crypt.nix).authorizedKeys;
    };
  };
}
