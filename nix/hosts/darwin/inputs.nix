{
  pkgs,
  userSettings,
  ...
}: {
  environment.systemPackages = with pkgs; [
    kanata # keyboard
    unnaturalscrollwheels # mouse
  ];

  launchd = {
    daemons = {
      ##### Keyboard #####
      # Kanata, a keyboard remapper
      # Ensure /run/current-system/sw/bin/kanata is whitelisted in Security & Privacy > Accessibility
      kanata = {
        command = "${pkgs.kanata}/bin/kanata --cfg '${userSettings.homeDir}/Library/Application Support/kanata/kanata.kbd'";
        serviceConfig = {
          KeepAlive = true;
          RunAtLoad = true;
          # StandardOutPath = "/tmp/kanata.log"; # For debugging if needed
          # StandardErrorPath = "/tmp/kanata.log";
        };
      };
      # Karabiner driver is needed by Kanata, instructions are adapted from:
      # https://github.com/jtroo/kanata/discussions/1537
      karabiner = {
        command = "'${pkgs.karabiner-elements.driver}/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon'";
        serviceConfig = {
          KeepAlive = true;
          RunAtLoad = true;
          # StandardOutPath = "/tmp/karabiner.log";
          # StandardErrorPath = "/tmp/karabiner.log";
        };
      };
    };

    agents = {
      ##### Mouse #####
      # UnnaturalScrollWheels doesn't start due to a bug: https://github.com/ther0n/UnnaturalScrollWheels/issues/51
      mouse = {
        command = "'/Applications/Nix Apps/UnnaturalScrollWheels.app/Contents/MacOS/UnnaturalScrollWheels'";
        serviceConfig = {
          KeepAlive = false; # So that we can stop it from bar
          RunAtLoad = true;
        };
      };
    };
  };

  # The Karabiner driver needs to be at least 6.0.0. This overlay can be removed in the future.
  nixpkgs.overlays = [
    (self: super: {
      karabiner-elements = super.karabiner-elements.overrideAttrs (old: {
        version = "15.4.0";

        src = super.fetchurl {
          inherit (old.src) url;
          hash = "sha256-VOIi5TPOp71o59vSxNztiZgseAA9Dqd8bC/8UhpFzKE=";
        };
      });
    })
  ];
}
