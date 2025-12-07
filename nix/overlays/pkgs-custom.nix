{
  pkgs,
  inputs,
  ...
}: {
  # This allows us to access custom packages:
  # - stable:   pkgs.custom.<program>
  nixpkgs.overlays = [
    (final: prev: {
      custom = {
        gocryptfs-scripts = prev.callPackage ../packages/gocryptfs-scripts.nix {};
        samsungtv-tizen = prev.home-assistant.python.pkgs.callPackage ../packages/samsungtv-tizen.nix {};
        swhkd = prev.callPackage ../packages/swhkd.nix {};
        wasg = prev.python3Packages.callPackage ../packages/wasg.nix {};
      };
    })
  ];
}
