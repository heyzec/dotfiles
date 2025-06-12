{inputs, ...}: let
  key = inputs.private.homelab.attributes.btrbk.key;
in {
  services.btrbk.sshAccess = [
    {
      roles = ["receive"];
      key = key;
    }
  ];
}
