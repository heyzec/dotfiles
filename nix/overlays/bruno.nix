# Use next version until https://github.com/usebruno/bruno/issues/7846 merged to nixpkgs
# issue: ctrl+enter causes newline
final: prev: let
  name = "bruno";
in {
  ${name} = prev.${name}.overrideAttrs (finalAttrs: prevAttrs: rec {
    version = "3.4.2";

    src = prevAttrs.src.override {
      tag = "v${version}";
      hash = "sha256-eDLHXOKhQBdRWZ9QGAVk4nky8vywYFAjUXCskFTunUo=";
    };

    npmDeps = final.fetchNpmDeps {
      inherit (finalAttrs) src;
      hash = "sha256-+wr86nNT9cT7Qy0gUfkFq0xFQaaWCrDTc1tg7A80pk4=";
    };

    # Cosmetic fix only beecause of our overlay
    prevVersion = "3.3.0";
    postPatch = builtins.replaceStrings [prevVersion] [version] prevAttrs.postPatch;
  });
}
