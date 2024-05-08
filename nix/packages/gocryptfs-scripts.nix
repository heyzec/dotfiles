{ pkgs, ... }:
let
  suffix = ".gocryptfs";

  unlock = pkgs.writeShellApplication {
    name = "unlock";
    text = ''
      suffix="${suffix}"
      cipherdir=$(find . -maxdepth 1 -name "*$suffix" | head -n1)
      mount=''${cipherdir//''${suffix}/}
      echo "Decrypting $cipherdir to $mount"
      gocryptfs "$cipherdir" "$mount"
    '';
  };
  lock = pkgs.writeShellApplication {
    name = "lock";
    text = ''
      suffix="${suffix}"
      cipherdir=$(find . -maxdepth 1 -name "*$suffix" | head -n1)
      mount=''${cipherdir//''${suffix}/}
      echo "Unmounting $cipherdir at $mount"
      umount "$mount"
    '';
  };
in
pkgs.stdenv.mkDerivation {
  name = "unlock";
  dontBuild = true;
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    cp ${unlock}/bin/unlock $out/bin/unlock
    cp ${lock}/bin/lock $out/bin/lock
  '';
}
