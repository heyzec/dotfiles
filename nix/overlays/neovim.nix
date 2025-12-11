# For https://github.com/neovim/neovim/issues/33869
final: prev: let
  name = "neovim-unwrapped";
in {
  ${name} = prev.${name}.overrideAttrs (finalAttrs: prevAttrs: {
    version = "v0.12.0-dev";

    src = final.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      tag = "nightly";
      hash = "sha256-huTBuxpjC7NoHfDI5TfroSghWjFyfUcSQWQznWu/J6c=";
    };
  });
}
