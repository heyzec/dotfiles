{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.aerospace
  ];
  services.aerospace = {
    enable = false;
  };
}
