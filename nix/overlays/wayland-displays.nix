{inputs, ...}: {
  nixpkgs.overlays = [
    (final: prev: {
      "wayland-displays" =
        inputs.wayland-displays.packages.x86_64-linux.default;
    })
  ];
}
