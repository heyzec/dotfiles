{
  lib,
  inputs,
  ...
}: {
  nixpkgs.overlays =
    map (p: import p) (lib.heyzec.umport {
      path = ./.;
    })
    ++ [
      (
        final: prev: {
          shopee = inputs.shopeepkgs.packages.aarch64-darwin;
        }
      )
    ];
}
