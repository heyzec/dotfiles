{ pkgs, ... }:
{
  imports = [
    ((import ./utils.nix).overrideNixpkgs {
      inherit pkgs;
      url = "https://github.com/DaniD3v/nixpkgs/archive/8760b755dc1db0ad9c65cdb1471df5962a21ef0e.tar.gz";
      sha256 = "159w1xbphapdrfy7c6rhy9q5i7acqai58b0igh8fn64m13k57scq";
      names = ["sddm-sugar-dark"];
    })
  ];
}
