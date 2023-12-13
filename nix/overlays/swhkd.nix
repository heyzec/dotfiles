{ pkgs, ... }:
let
    nixpkgs-alt = builtins.fetchTarball {
        url = "https://github.com/mibmo/nixpkgs/archive/21a5faab9cf2779b566abf6ec730d31489f2b749.tar.gz";
        sha256 = "192m8b8lrq85irlxmdrlzksswb16hbjqc292mh0fmqip3k4zs0qf";
     };
    nixpkgs-alt2 = import (nixpkgs-alt) { inherit (pkgs) system; };
in
{
  nixpkgs.overlays = [
    (final: prev: {
      swhkd = nixpkgs-alt2.swhkd;
    })
  ];
  #
  # imports = [
  #   "${nixpkgs-alt}/nixos/modules/services/hardware/keyd.nix"
  # ];
  # disabledModules = [
  #   "services/hardware/keyd.nix"
  # ];
}
