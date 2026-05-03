{
  inputs,
  hasPrivate,
  ...
}: let
  authorizedKeys = inputs.private.homelab.attributes.users.authorizedKeys;
  ifHasPrivate = expr:
    if hasPrivate
    then expr
    else [];
in {
  users.users."bee" = {
    isNormalUser = true;
    # uid = 1000;
    extraGroups = [
      "wheel"
      "video"
      "hass" # to access /var/lib/hass/
    ];

    openssh.authorizedKeys.keys = ifHasPrivate authorizedKeys.bee;
  };
  users.users."restic" = {
    isNormalUser = true;
    uid = 1001;
    extraGroups = ["sftponly"];
    openssh.authorizedKeys.keys = ifHasPrivate authorizedKeys.restic;
    home = "/restic";
  };

  users.groups."sftponly" = {};
}
