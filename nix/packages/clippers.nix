{
  rustPlatform,
  fetchFromGitHub,
  ...
}:
rustPlatform.buildRustPackage {
  pname = "clippers";
  version = "next-lock";

  src = fetchFromGitHub {
    owner = "heyzec";
    repo = "clippers";
    rev = "dde06b737e00e24cf095f86dbe93fae3be34d89b"; # next-lock
    hash = "sha256-jL3dj4our8jkl2RBUOZPfD4dtHdjoGSi+q7ATMDgdR8=";
  };

  # Idea: have a overlay that takes in a package, wraps it to take in a --override flag. then, you can override it with a path to local build

  cargoHash = "sha256-I4aAFuHvBthNE3E+rfY+KZEB9WxyXil+onoXGsrwx5s=";
}
