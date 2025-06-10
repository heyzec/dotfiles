{
  pkgs,
  inputs,
  ...
}: {
  # This allows us to access stable packages:
  # - unstable: pkgs.<program>
  # - stable:   pkgs.stable.<program>
  nixpkgs.overlays = [
    (final: prev: {
      stable = import inputs.nixpkgs-stable {
        system = pkgs.stdenv.system;
        config.allowUnfree = true;
      };
    })
  ];
}
