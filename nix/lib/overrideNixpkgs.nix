{
  url,
  sha256,
  names,
  moduleToDisable ? null,
  pkgs
}: let
  nixpkgs-alt-raw = builtins.fetchTarball {
    inherit url;
    inherit sha256;
  };
  nixpkgs-alt = import (nixpkgs-alt-raw) { inherit (pkgs) system; };
in {
  nixpkgs.overlays = [
    (final: prev:
      builtins.listToAttrs (builtins.map (name: {
        name = name;
        value = nixpkgs-alt.${name};
      }) names)
    )
  ];

  imports = if moduleToDisable == null then [] else [
    "${nixpkgs-alt-raw}/nixos/modules/${moduleToDisable}"
  ];

  disabledModules = if moduleToDisable == null then [] else [
    moduleToDisable
  ];
}
