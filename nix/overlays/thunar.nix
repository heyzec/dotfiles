# Remove desktop entry "Thunar Preferences" from launcher
# This is because "Thunar Preferences" is ordered before "Thunar File Manager" by rofi
# The more ideal solution is to make launcher sort by most recently used
final: prev: {
  # https://nixos.org/manual/nixpkgs/stable/#trivial-builder-symlinkJoin
  thunar-unwrapped = prev.symlinkJoin {
    inherit (prev.thunar-unwrapped) name version meta;

    paths = [prev.thunar-unwrapped prev.thunar-unwrapped.dev];

    postBuild = ''
      rm $out/share/applications/thunar-settings.desktop
    '';
  };
}
