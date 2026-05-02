{
  eudev,
  fetchFromGitHub,
  pkg-config,
  rustPlatform,
  scdoc,
}:
rustPlatform.buildRustPackage rec {
  pname = "swhkd";
  version = "0f8a2af6a605adcfb06ae0bcb5dce9353169b598";

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = "swhkd";
    rev = version;
    hash = "sha256-KjuBy8RDy/5SqX5zZWfzYPcpfJ92Cohf2CrkMC6ZtjA=";
  };
  patches = [
    ./swhkd-fix-groups.patch
    ./swhks-fix-device-sep.patch
    ./swhks-hardcode-loginuid-1000.patch
  ];

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
