# For https://github.com/neovim/neovim/issues/33869
final: prev: {
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (old: rec {
    version = "v0.12.2";

    src = final.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "${version}";
      hash = "sha256-V+jZiNv0SvG/GOOUPzmBkOQGrnrN3UW2BY2n9NxP2Eg=";
    };
  });
}
