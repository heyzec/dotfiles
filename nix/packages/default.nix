{pkgs, ...}: {
  gocryptfs-scripts = pkgs.callPackage ./gocryptfs-scripts.nix {};
  swhkd = pkgs.callPackage ./swhkd.nix {};
  wasg = pkgs.python3Packages.callPackage ./wasg.nix {};
}
