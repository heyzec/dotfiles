{lib, ...}: {
  imports =
    lib.heyzec.umport {
      path = ./.;
    }
    ++ [
      ../modules/neovim.nix
      ../modules/shell.nix
      ./linux
    ];
}
