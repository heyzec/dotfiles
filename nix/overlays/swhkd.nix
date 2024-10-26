{
  lib,
  pkgs,
  ...
}: {
  imports = [
    (lib.heyzec.overrideNixpkgs {
      inherit pkgs;
      url = "https://github.com/mibmo/nixpkgs/archive/03cccb60c220ba25a0aa7be7221204156fe29bc6.tar.gz";
      sha256 = "17ffvjv65r8zy5vdva3f29r2bbrsm4rmiyl8f5mqsbwkx5g7crw6";
      names = ["swhkd"];
    })
  ];
}
# This overlay is based off a closed PR on the Nixpkgs repository.
# In case the commit is lost, the contents of the PR is included below.
# From 03cccb60c220ba25a0aa7be7221204156fe29bc6 Mon Sep 17 00:00:00 2001
# From: mib <mib@mib.dev>
# Date: Sat, 16 Sep 2023 00:06:07 +0200
# Subject: [PATCH] swhkd: init at 1.2.2
#
# ---
#  pkgs/by-name/sw/swhkd/package.nix | 30 ++++++++++++++++++++++++++++++
#  1 file changed, 30 insertions(+)
#  create mode 100644 pkgs/by-name/sw/swhkd/package.nix
#
# diff --git a/pkgs/by-name/sw/swhkd/package.nix b/pkgs/by-name/sw/swhkd/package.nix
# new file mode 100644
# index 0000000000000..e3aa86ab51397
# --- /dev/null
# +++ b/pkgs/by-name/sw/swhkd/package.nix
# @@ -0,0 +1,30 @@
# +{ lib
# +, fetchFromGitHub
# +, rustPlatform
# +}:
# +
# +rustPlatform.buildRustPackage rec {
# +  pname = "swhkd";
# +  version = "1.2.2";
# +
# +  src = fetchFromGitHub {
# +    owner = "waycrate";
# +    repo  = "swhkd";
# +    rev = version;
# +    hash = "sha256-mpE+//a44wwraCCpBTnWXslLROF2dSIcv/kdpxHLD4M=";
# +  };
# +
# +  cargoHash = "sha256-H14YwK4Ow86UxVXoclCjk2xYtu8L/44zkzf9gpveAh8=";
# +
# +  meta = with lib; {
# +    description = "Display protocol-independent hotkey daemon";
# +    longDescription = ''
# +      A display protocol-independent hotkey daemon made in Rust.
# +      Uses an easy-to-use configuration system inspired by sxhkd, so you can easily add or remove hotkeys.
# +      Attempts to be a drop-in replacement of sxhkd, meaning your sxhkd config file should be compatible with swhkd.
# +    '';
# +    license = licenses.bsd2;
# +    maintainers = with maintainers; [ mib ];
# +    platforms = platforms.linux;
# +  };
# +}

