{
  # enroll fingerprint properly with fprintd-enroll
  # see also: https://discourse.nixos.org/t/nixos-unstable-fprintd-fingerprint-reader-issues/33273/2

  services.fprintd.enable = true; # also enabled by nixos-hardware for Dell XPS 13 9310

  # Since the fingerprint reader is unreliable and PAM currently doesn't support parallel auth,
  # enabling it by default can lock us out. Therefore, we disable fingerprint by default.
  # (this is not an issue for hyprlock)
  security.pam.services.login.fprintAuth = false;
  security.pam.services.sudo.fprintAuth = false;
}
