# For https://github.com/neovim/neovim/issues/33869
{
  nixpkgs.overlays = [
    (self: super: {
      neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (old: rec {
        version = "v0.12.0-dev";

        src = self.fetchFromGitHub {
          owner = "neovim";
          repo = "neovim";
          tag = "nightly";
          hash = "sha256-huTBuxpjC7NoHfDI5TfroSghWjFyfUcSQWQznWu/J6c=";
        };
      });
    })
  ];
}
