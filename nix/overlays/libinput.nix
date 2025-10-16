{fetchFromGitLab, ...}: let
  name = "libinput";
in {
  imports = [
    {
      nixpkgs.overlays = [
        (final: prev: {
          # Use my personal nixpkgs branch awaiting merge to NixOS master
          ${name} = prev.${name}.overrideAttrs (finalAttrs: prevAttrs: {
            # Touchpad wonky
            # https://bbs.archlinux.org/viewtopic.php?id=308400
            src = fetchFromGitLab {
              domain = "gitlab.freedesktop.org";
              owner = "libinput";
              repo = "libinput";
              rev = "1.28.1";
              hash = "sha256-kte5BzGEz7taW/ccnxmkJjXn3FeikzuD6Hm10l+X7c0=";
            };
          });
        })
      ];
    }
  ];
}
