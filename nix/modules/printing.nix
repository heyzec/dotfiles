{ pkgs, ... }:

{
  # PRINTERS
  services.printing.enable = true;

  # SCANNERS
  hardware.sane = {
    enable = true; extraBackends = [ pkgs.utsushi ];
  };
  # use epsonscan nexttime
  services.udev.packages = [ pkgs.utsushi ];
}
