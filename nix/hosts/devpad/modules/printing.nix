# peripherals.nix
{pkgs, ...}: {
  ################################################################################
  ##### Printers
  ################################################################################
  services.printing.enable = true;
  # services.printing.logLevel = "debug";
  hardware.printers = {
    ensureDefaultPrinter = "Epson-L360";
    ensurePrinters = [
      {
        name = "Epson-L360";
        # To find device URI, use `lpinfo -v`
        deviceUri = "usb://EPSON/L360%20Series?serial=5647444B3331343958&interface=1";
        location = "home";
        model = "gutenprint.5.3://escp2-l310/expert";
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
  };
  services.printing.drivers = with pkgs; [
    gutenprint
    gutenprintBin
  ];

  ################################################################################
  ##### Scanners
  ################################################################################
  hardware.sane = {
    enable = true;

    drivers.scanSnap.enable = true;
    extraBackends = with pkgs; [
      utsushi # for some Epson scanners
      sane-airscan # for "driverless" scanning
    ];
  };
  # use epsonscan nexttime
  services.udev.packages = [pkgs.utsushi];
}
