{
  pkgs,
  userSettings,
  ...
}: {
  environment.systemPackages = with pkgs; [
    kanata
  ];
  launchd = {
    daemons = {
      # Kanata, a keyboard remapper
      kanata = {
        command = "${pkgs.kanata}/bin/kanata --cfg '${userSettings.homeDir}/Library/Application Support/kanata/kanata.kbd'";
        serviceConfig = {
          KeepAlive = true;
          RunAtLoad = true;
        };
      };
      # Karabiner driver is needed by Kanata and to be installed separately
      # https://github.com/jtroo/kanata/discussions/1537
      karabiner = {
        command = "'/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon'";
        serviceConfig = {
          KeepAlive = true;
          RunAtLoad = true;
        };
      };
    };
  };
}
