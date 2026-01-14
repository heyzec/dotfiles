# For https://github.com/neovim/neovim/issues/33869
final: prev: {
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (old: rec {
    version = "v0.12.0-dev";

    src = final.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "23bf4c0531acef4e8252f4db13fcd90ad5aa91bf";
      hash = "sha256-FJZZRSj9YsWjEuXqGQEE00Uxc1pIp7lon6cYzEU3yKg=";
    };
  });
}
