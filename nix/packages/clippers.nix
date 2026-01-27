{
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "clippers";
  version = "6243eea57fdf3946096b77c4be3fdb876312e926";

  src = fetchFromGitHub {
    owner = "heyzec";
    repo = pname;
    rev = version;
    hash = "sha256-7KX72mLWsj7YOXWjeMJbTaQi74A9KnfMa3o2lzPaoeY=";
  };

  cargoHash = "sha256-GdnW9qyTJqt6VW1UCf9Bd13WeWvcWapRCbiw+H0FMwI=";
}
