{ pkgs, ... }:
let
    nixpkgs-alt = builtins.fetchTarball {
        url = "https://github.com/JohnAZoidberg/nixpkgs/archive/6591d332f93422e388ef6337f6b362b4ff8d0724.tar.gz";
        sha256 = "0qwvis3g6fqccj51sysj63hq2083pilfs3l1kkxhrd8fg291bkb6";
     };
    nixpkgs-alt2 = import (nixpkgs-alt) { inherit (pkgs) system; };
in
{
  nixpkgs.overlays = [
    (final: prev: {
      keyd = nixpkgs-alt2.keyd;
    })
  ];

  imports = [
    "${nixpkgs-alt}/nixos/modules/services/hardware/keyd.nix"
  ];
  disabledModules = [
    "services/hardware/keyd.nix"
  ];
}
