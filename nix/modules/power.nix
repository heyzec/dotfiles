# Power management module with sane defaults. Features:
# - Configurable durations to blank screen and suspend-then-hibernate after idle
# - Lock screen after waking up from idle timeout
# - Enable suspend-then-hibernate and patch wlogout to use it
#
# It serves as a wrapper over hypridle, wlogout and systemd-sleep.
# hypridle must still be daemonised manually with config at /etc/hypr/hypridle.conf (this is non-standard)

{ lib, config, pkgs, ... }:
{
  options = {
    heyzec.power = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "";
      };

      blankAfter = lib.mkOption {
        type = with lib.types; nullOr int;
        default = null;
        description = "Number of seconds after idle to turn off the display";
      };

      sleepAfter = lib.mkOption {
        type = with lib.types; nullOr int;
        default = null;
        description = "Number of seconds after idle to put the computer to sleep";
      };

      hibernateAfter = lib.mkOption {
        type = with lib.types; nullOr int;
        default = null;
        description = "Number of seconds after sleep to put the computer to hibernate";
      };

      # hypridleGeneralConfig = lib.mkOption {
      #   type = with lib.types; attrsOf str;
      #   default = {};
      #   description = "Config for hypridle's general section";
      # };

      commandLockScreen = lib.mkOption {
        type = lib.types.str;
        default = "loginctl lock-session";
        description = "Command to execute screen locker program";
      };

      commandBlankScreen = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = "Command to execute to blank screen";
      };

      commandUnblankScreen = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = "Command to execute to unblank screen";
      };
    };
  };

  config = with config.heyzec; {
    environment.etc = if ! power.enable then {} else {
      "hypr/hypridle.conf" = {
        text =
        # ''
        #   general {
        #     ${with lib; concatStringsSep "\n" (attrsets.mapAttrsToList (name: value: "${name} = ${value}") power.hypridleGeneralConfig)}
        #   }
        # '' +

        ''
          general {
            after_sleep_cmd = ${power.commandLockScreen};
          }
        '' +

        (if power.blankAfter == null then "" else
          (if power.commandBlankScreen == null || power.commandUnblankScreen == null then
          abort "commandBlankScreen and commandUnblankScreen must be specified if blankAfter is specified" else
          ''
            listener {
              timeout = ${toString power.blankAfter}
              on-timeout = ${power.commandBlankScreen}
              on-resume = ${power.commandUnblankScreen}
            }
          '')
          ) +

        (if power.sleepAfter == null then "" else ''
          listener {
            timeout = ${toString power.sleepAfter}
            on-timeout = systemctl suspend-then-hibernate
          }
        '');
      };
    };

    # Added to [Sleep] section
    systemd.sleep.extraConfig = if power.enable && power.hibernateAfter != null then ''
      HibernateDelaySec=${builtins.toString power.hibernateAfter}
    '' else "";


    environment.systemPackages = [
      (pkgs.runCommand "wlogout" {
        buildInputs = [ pkgs.makeWrapper ];
      } ''
        mkdir $out
        ln -s ${pkgs.wlogout}/* $out
        rm $out/etc
        mkdir -p $out/etc/wlogout
        ln -s ${pkgs.wlogout}/etc/wlogout/* $out/etc/wlogout
        rm $out/etc/wlogout/layout
        cp ${pkgs.wlogout}/etc/wlogout/layout $out/etc/wlogout/layout

        substituteInPlace $out/etc/wlogout/layout \
          --replace "systemctl suspend" "systemctl suspend-then-hibernate"

        # TODO: Try to make swaylock respond to loginctl instead
        substituteInPlace $out/etc/wlogout/layout \
          --replace "loginctl lock-session" commandLock
      '')
    ];
  };
}
