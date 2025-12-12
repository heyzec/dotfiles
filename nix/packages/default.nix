{pkgs, ...}: {
  ctpv = pkgs.callPackage ./ctpv.nix {};
  gocryptfs-scripts = pkgs.callPackage ./gocryptfs-scripts.nix {};
  samsungtv-tizen = pkgs.home-assistant.python.pkgs.callPackage ./samsungtv-tizen.nix {};
  swhkd = pkgs.callPackage ./swhkd.nix {};
  wasg = pkgs.python3Packages.callPackage ./wasg.nix {};
}
