# This file was the original file I hacked together. It does not provide swhkd user service
# To use: Add this to packages:
#     # (pkgs.callPackage ./extrapackages/derivation.nix {})
# Then, add this polkit config:
#  security.polkit.extraConfig = ''
#    polkit.addRule(function(action, subject) {
#        if (action.id == "com.github.swhkd.pkexec"  &&
#            subject.local == true &&
#            subject.active == true &&) {
#                return polkit.Result.YES;
#        }
#    });
#  '';
# Lastly, ensuer XDG_CONFIG_HOME is not set because swhkd needs to assume config
# location is at /etc/swhkd/swhkdrc
{ 
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  polkit
}:


rustPlatform.buildRustPackage rec {
  name = "swhkd";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "waycrate"; 
    repo = "swhkd"; 
    # rev = "${version}";
    rev = "ddada68da7feeef26acad47ec4194c6315b4fccb";
    hash = "sha256-JV/fUnS+7EsyrthEs3ABUBN291VUPjnKG1GsmrG53vI=";
  };

  # cargoSha256 = "mSgoePNwnLmekxkKJlx4NeF/BpQp9t2XSZelGUj7SEo=";
  cargoSha256 = "yHUkykn9AlRtFRWCg/CacT0eKZ2LNOXFpC2BE8sBuwE=";
  # cargoLock.lockFile = ./Cargo.lock;


  buildInputs = [ polkit.bin ];

  preConfigure = ''
    # For ITS rules
    addToSearchPath "XDG_DATA_DIRS" "${polkit.out}/share"
  '';
  cargoCheckHook = false;

  # unpackPhase = let
  postInstall = let
    TARGET_DIR = "$out";
    POLKIT_POLICY_FILE = "com.github.swhkd.pkexec.policy";
    POLKIT_DIR = "usr/share/polkit-1/actions";
    DAEMON_BINARY = "bin/swhkd";

  in ''
    set -x

    ls
    $src/scripts/build-polkit-policy.sh \
		--policy-path=${POLKIT_POLICY_FILE} \
		--swhkd-path=/run/current-system/sw/bin/swhkd
    ls
    install -D ./${POLKIT_POLICY_FILE} -t $out/share/polkit-1/actions/
  '';


}
