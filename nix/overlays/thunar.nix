# Remove desktop entry "Thunar Preferences" from launcher
# This is because "Thunar Preferences" is ordered before "Thunar File Manager" by rofi
# The more ideal solution is to make launcher sort by most recently used
final: prev: {
  # https://wiki.nixos.org/wiki/Overlays#Overriding_a_package_inside_a_scope
  xfce = prev.xfce.overrideScope (xfinal: xprev: {
    # https://nixos.org/manual/nixpkgs/stable/#trivial-builder-symlinkJoin
    thunar-unwrapped = prev.symlinkJoin {
      inherit (xprev.thunar-unwrapped) name version meta;

      paths = [xprev.thunar-unwrapped xprev.thunar-unwrapped.dev];

      postBuild = ''
        rm $out/share/applications/thunar-settings.desktop
      '';
    };
  });
}
