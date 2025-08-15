let
  name = "indicator-sound-switcher";
in {
  imports = [
    {
      nixpkgs.overlays = [
        (final: prev: {
          # Use my personal nixpkgs branch awaiting merge to NixOS master
          ${name} = prev.${name}.overrideAttrs (finalAttrs: prevAttrs: {
            # Patch icons to white, since symbolic icons are an issue in waybar
            postInstall = ''
              find $out/share/icons -name '*.png' -exec ${prev.imagemagick}/bin/convert "{}" -fuzz 50% -fill white -opaque black "{}" \;
            '';
          });
        })
      ];
    }
  ];
}
