{
  users.users."pi" = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "video" ];
    openssh.authorizedKeys.keys = (import ./users.crypt.nix).pi-keys;
  };
  users.users."restic" = {
    isNormalUser = true;
    uid = 1001;
    extraGroups = [ "sftponly" ];
    openssh.authorizedKeys.keys = (import ./users.crypt.nix).restic-keys;
    home = "/restic";
  };
  users.users."btrbk" = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = (import ./users.crypt.nix).btrbk-keys;
  };

  users.groups."sftponly" = {};
}

