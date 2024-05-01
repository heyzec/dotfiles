{ lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ] ++ lib.heyzec.umport {
    path = ./.;
  };
}
