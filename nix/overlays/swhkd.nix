{ pkgs, ... }:
{
  imports = [
    ((import ./utils.nix).overrideNixpkgs {
      inherit pkgs;
      url = "https://github.com/mibmo/nixpkgs/archive/21a5faab9cf2779b566abf6ec730d31489f2b749.tar.gz";
      sha256 = "192m8b8lrq85irlxmdrlzksswb16hbjqc292mh0fmqip3k4zs0qf";
      names = ["swhkd"];
    })
  ];
}
