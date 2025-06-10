{
  imports = [
    ./hardware
    ./modules
  ];

  security.polkit.enable = true;

  nix.settings.trusted-users = ["pi"]; # https://github.com/NixOS/nix/issues/2127#issuecomment-1465191608
}
