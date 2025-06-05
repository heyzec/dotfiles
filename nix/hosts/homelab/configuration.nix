{inputs, ...}: {
  imports =
    [
      ./hardware
      ./modules
    ]
    ++ (
      if inputs.private.hasPrivate
      then [
        inputs.private.homelab.modules
        inputs.private.homelab.secrets
      ]
      else []
    );

  security.polkit.enable = true;

  nix.settings.trusted-users = ["pi"]; # https://github.com/NixOS/nix/issues/2127#issuecomment-1465191608
}
