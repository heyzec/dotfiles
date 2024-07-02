{ lib, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      "flameshot" = (prev.flameshot.overrideAttrs (prevAttrs: {
        src = prev.fetchFromGitHub {
          owner = "flameshot-org";
          repo = "flameshot";
          rev = "f04d22b5af5934f73c14c05e160a934ea6a0d98c";
          sha256 = "sha256-7knUsv66sIrNePUVmA4quhCE1qvEikipqOnPUUZESZY=";
        };

        cmakeFlags = prevAttrs.cmakeFlags ++ [
          (lib.cmakeBool "USE_WAYLAND_GRIM" true)
        ];
      }));
    })
  ];
}

