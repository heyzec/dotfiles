# use previous version until https://redirect.github.com/Alexays/Waybar/issues/4156 fixed
final: prev: let
  name = "grimblast";
in {
  ${name} = prev.${name}.overrideAttrs (finalAttrs: prevAttrs: {
    src = prevAttrs.src.override {
      rev = "3ecd35a13957021f2f37fd3b2702e241e1c56f61";
      hash = "sha256-/WoFPPdhciTcv2xS4Eo/7Uhh85LRia2V9h6Crecc1eM=";
    };
  });
}
