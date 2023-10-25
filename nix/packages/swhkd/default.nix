# Adapted from various other people's code on github
{
  lib,
  rustPlatform,
  makeWrapper,
  psmisc,
  runtimeShell,
  fetchFromGitHub,
  polkit

}:
let
in
rustPlatform.buildRustPackage {

  name = "swhkd";
  version = "1.2.1";
  src = fetchFromGitHub {
    owner = "waycrate"; 
    repo = "swhkd"; 
    rev = "ddada68da7feeef26acad47ec4194c6315b4fccb";
    hash = "sha256-JV/fUnS+7EsyrthEs3ABUBN291VUPjnKG1GsmrG53vI=";
  };
  cargoSha256 = "yHUkykn9AlRtFRWCg/CacT0eKZ2LNOXFpC2BE8sBuwE=";


  nativeBuildInputs = [makeWrapper];
  buildInputs = [polkit.bin];

  # From gparted's derivation, may not be needed
  preConfigure = ''
    # For ITS rules
    addToSearchPath "XDG_DATA_DIRS" "${polkit.out}/share"
  '';

  postBuild = ''
    ./scripts/build-polkit-policy.sh \
    --policy-path=com.github.swhkd.pkexec.policy \
    --swhkd-path=/usr/bin/swhkd
  '';

  postInstall = let
      POLKIT_POLICY_FILE = "com.github.swhkd.pkexec.policy";
  in ''
    cp ${./swhkd.service} ./swhkd.service
    install -D -m0444 -t "$out/lib/systemd/user" ./swhkd.service
    substituteInPlace "$out/lib/systemd/user/swhkd.service" \
      --replace @out@ "$out/share/swhkd/hotkeys.sh"


    cp ${./hotkeys.sh} ./hotkeys.sh
    install -D -m0444 -t "$out/share/swhkd" ./hotkeys.sh
    chmod +x "$out/share/swhkd/hotkeys.sh"
    substituteInPlace "$out/share/swhkd/hotkeys.sh" \
      --replace @runtimeShell@ "${runtimeShell}" \
      --replace @psmisc@ "${psmisc}" \
      --replace @out@ "$out"


    install -D -m0444 -t "$out/share/polkit-1/actions" ./${POLKIT_POLICY_FILE}
    substituteInPlace "$out/share/polkit-1/actions/${POLKIT_POLICY_FILE}" \
      --replace /usr/bin/swhkd \
        "$out/bin/swhkd"
  '';
}
