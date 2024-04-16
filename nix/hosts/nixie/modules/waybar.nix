{ pkgs, ...}:

  # Enabling waybar to use different channel
  # See https://github.com/NixOS/nixpkgs/issues/41212


{
  programs.waybar = {
    enable = true;
      # See https://github.com/hyprwm/Hyprland/issues/725#issuecomment-1541364919
      package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or  []) ++ [ "-Dexperimental=true" ];
      patches = (oa.patches or []) ++ [
        (pkgs.fetchpatch {
          name = "fix waybar hyprctl";
          url = "https://aur.archlinux.org/cgit/aur.git/plain/hyprctl.patch?h=waybar-hyprland-git";
          sha256 = "sha256-pY3+9Dhi61Jo2cPnBdmn3NUTSA8bAbtgsk2ooj4y7aQ=";
        })
      ];
    });
  };
}
