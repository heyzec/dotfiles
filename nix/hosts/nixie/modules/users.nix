{ pkgs, userSettings, ... }:
{
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;

    users.${userSettings.username} = {
      isNormalUser = true;
      uid = 1000;
      description = "Main user of this device";

      extraGroups = [
        # See here for a brief explaination of each group
        # https://wiki.archlinux.org/title/users_and_groups#Group_list
        "wheel"            # Access sudo command
        "networkmanager"   # Access network manager
        # "uinput"
        # "input" # Unsafe
        # "video"
        "ic2"              # Control /dev/i2c-* devices
      ] ++ [
        "plocate"
        "docker"           # Run docker without sudo
        "wireshark"        # Capture interfaces without sudo
        "libvirtd"
        "beep" # Testing
      ];

      hashedPassword = (import ./users.crypt.nix).hashedPassword;
      openssh.authorizedKeys.keys = (import ./users.crypt.nix).authorizedKeys;
    };
  };
}
