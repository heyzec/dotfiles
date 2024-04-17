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
    ];
    shell = pkgs.zsh;
    hashedPassword = (import ./users.crypt.nix).hashedPassword;
  };
}
