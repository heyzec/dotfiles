# For controlling TVs via HDMI-CEC
# https://wiki.nixos.org/wiki/NixOS_on_ARM/Raspberry_Pi_4#HDMI-CEC
{ pkgs, ... }:
{
  # an overlay to enable raspberrypi support in libcec, and thus cec-client
  nixpkgs.overlays = [
    (self: super: { libcec = super.libcec.override { withLibraspberrypi = true; }; })
  ];

  services.udev.extraRules = ''
    # allow access to raspi cec device for video group (and optionally register it as a systemd device, used below)
    SUBSYSTEM=="vchiq", GROUP="video", MODE="0660", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/dev/vchiq"
  '';

  environment.systemPackages = with pkgs; [
    libcec  # provides cec-client command
  ];
}
