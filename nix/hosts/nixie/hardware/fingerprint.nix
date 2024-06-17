{
  # nixos-hardware already enables fprintd by default
  # Note: enroll properly
  # https://discourse.nixos.org/t/nixos-unstable-fprintd-fingerprint-reader-issues/33273/2

  security.pam.services.login.fprintAuth = false;
  security.pam.services.swaylock.fprintAuth = false;
  security.pam.services.sudo.fprintAuth = false;
}
