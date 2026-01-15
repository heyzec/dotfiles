{
  nixpkgs.overlays = [
    (self: super: {
      aerospace = super.aerospace.overrideAttrs (old: rec {
        version = "0.19.2-Beta";

        src = super.fetchzip {
          url = "https://github.com/nikitabobko/AeroSpace/releases/download/v${version}/AeroSpace-v${version}.zip";
          hash = "sha256-6RyGw84GhGwULzN0ObjsB3nzRu1HYQS/qoCvzVWOYWQ=";
        };
      });
    })
  ];
}
