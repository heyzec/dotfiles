{
  inputs,
  hasPrivate,
  ...
}:
if hasPrivate
then let
  key = inputs.private.homelab.attributes.btrbk.key;
in {
  services.btrbk.sshAccess = [
    {
      roles = ["receive"];
      key = key;
    }
  ];
}
else {}
