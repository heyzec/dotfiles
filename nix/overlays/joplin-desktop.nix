{ lib, pkgs, ... }:
{
  imports = [
    (lib.heyzec.overrideNixpkgs {
      inherit pkgs;
      url = "https://github.com/pmiddend/nixpkgs/archive/c8da1c41bb3ad269847d6523b17ffb1435472c6f.tar.gz";
      sha256 = "19fqfin2i3k4vxl34bz235qahz1zbv2fw63clkswv18556hgfl9n";
      names = ["joplin-desktop"];
    })
  ];
}
