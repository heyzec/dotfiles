{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kanata
  ];
  launchd = {
    agents = {
      karabiner = {
        # Karabiner driver
        command = "/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon";

        serviceConfig = {
          KeepAlive = true;
          RunAtLoad = true;
        };
      };
      kanata = {
        command = "${pkgs.kanata}/bin/kanata --cfg /Users/SP15013/.config/kanata/kanata.kbd";
        serviceConfig = {
          KeepAlive = true;
          RunAtLoad = true;
        };
      };
    };
  };
}
