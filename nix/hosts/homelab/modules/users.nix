{inputs, ...}: let
  keys = inputs.private.homelab.attributes.users.keys;
  ifHasPrivate = expr:
    if inputs.private.hasPrivate
    then expr
    else [];
in {
  users.users."pi" = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = ["wheel" "video"];
    openssh.authorizedKeys.keys = ifHasPrivate keys.pi;
  };
  users.users."restic" = {
    isNormalUser = true;
    uid = 1001;
    extraGroups = ["sftponly"];
    openssh.authorizedKeys.keys = ifHasPrivate keys.restic;
    home = "/restic";
  };
  users.users."btrbk" = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = keys.btrbk;
  };

  users.groups."sftponly" = {};
}
