{ pkgs, ... }:
# Override both nixpkgs and derivation
let
  name = "indicator-sound-switcher";

  url = "https://github.com/heyzec/nixpkgs/archive/3331411a53950c6fe63e2d9320f7b8f30c51e4a8.tar.gz";
  sha256 = "1wppp7q91hc4xsnmppf3gv37lbgy45lnz7h3vwzcnn1zbvimd2v8";

  nixpkgs-alt-raw = builtins.fetchTarball {
    inherit url;
    inherit sha256;
  };
  nixpkgs-alt = import (nixpkgs-alt-raw) { inherit (pkgs) system; };
in
{
  imports = [
    {
      nixpkgs.overlays = [
        (final: prev: {
          # Use my personal nixpkgs branch awaiting merge to NixOS master
          ${name} = (nixpkgs-alt.${name}.overrideAttrs (finalAttrs: prevAttrs: {
            # Patch icons to white, since symbolic icons are an issue in waybar
            postInstall = ''
              find $out/share/icons -name '*.png' -exec ${nixpkgs-alt.imagemagick}/bin/convert "{}" -fuzz 50% -fill white -opaque black "{}" \;
            '';
          }));
        })
      ];
    }
  ];
}
