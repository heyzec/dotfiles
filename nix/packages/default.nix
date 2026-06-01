{pkgs, ...}: {
  gocryptfs-scripts = pkgs.callPackage ./gocryptfs-scripts.nix {};
  happy-coder = pkgs.callPackage ./happy-coder.nix {};
  swhkd = pkgs.callPackage ./swhkd.nix {};
  wasg = pkgs.python3Packages.callPackage ./wasg.nix {};
}
