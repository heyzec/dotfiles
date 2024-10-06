{ pkgs, ... }:

{
  # PRINTERS
  # Disable
  services.printing.enable = false;

  # SCANNERS
  hardware.sane = {
    enable = true;

    drivers.scanSnap.enable = true;
    extraBackends = with pkgs; [
      utsushi # for some Epson scanners
      sane-airscan         # for "driverless" scanning
    ];
  };
  # use epsonscan nexttime
  services.udev.packages = [ pkgs.utsushi ];
}
