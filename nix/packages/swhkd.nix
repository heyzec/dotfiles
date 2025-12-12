{
  eudev,
  fetchFromGitHub,
  pkg-config,
  rustPlatform,
  scdoc,
}:
rustPlatform.buildRustPackage rec {
  pname = "swhkd";
  version = "ae372e0aff2e87fbfed11d79bcd7fd9ef5f68a60";

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = "swhkd";
    rev = version;
    hash = "sha256-EhbRIlI+RsZjPjbYmgu4WzOHJ8udTtlxgJ2kr9iHyd0=";
  };
  patches = [./swhkd.patch];

  cargoHash = "sha256-LBbmFyddyw7vV5voctXq3L4U3Ddbh428j5XbI+td/dg=";

  buildInputs = [
    eudev
  ];

  nativeBuildInputs = [
    scdoc
    pkg-config
  ];

  buildFeatures = [
    # See https://github.com/waycrate/swhkd/issues/310
    "no_rfkill"
  ];
}
