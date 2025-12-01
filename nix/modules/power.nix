# Power management module with sane defaults. Features:
# - Configurable durations to blank screen and suspend-then-hibernate after idle
# - Lock screen after waking up from idle timeout
# - Enable suspend-then-hibernate and patch wlogout to use it
#
# It serves as a wrapper over hypridle, wlogout and systemd-sleep.
# hypridle must still be daemonised manually with config at /etc/hypr/hypridle.conf (this is non-standard)

{ lib, config, pkgs, ... }:
let
  cfg = config.heyzec.power;
in
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

  config = {
    # By default, lid switch is ignored when docked (but not on AC)
    services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";

    environment.etc = if ! cfg.enable then { } else {
      "hypr/hypridle.conf" = {
        text = ''
          general {
            after_sleep_cmd = ${cfg.commandLockScreen};
          }
        '' +
        (if cfg.blankAfter == null then "" else
        (if cfg.commandBlankScreen == null || cfg.commandUnblankScreen == null then
          abort "commandBlankScreen and commandUnblankScreen must be specified if blankAfter is specified" else
          ''
            listener {
              timeout = ${toString cfg.blankAfter}
              on-timeout = ${cfg.commandBlankScreen}
              on-resume = ${cfg.commandUnblankScreen}
            }
          '')
        ) +

        (if cfg.sleepAfter == null then "" else ''
          listener {
            timeout = ${toString cfg.sleepAfter}
            on-timeout = systemctl suspend-then-hibernate
          }
        '');
      };
    };

    # Added to [Sleep] section
    systemd.sleep.extraConfig =
      if cfg.enable && cfg.hibernateAfter != null then ''
        HibernateDelaySec=${builtins.toString cfg.hibernateAfter}
      '' else "";


    environment.systemPackages = [
      # wlogout, patched with our commands
      (pkgs.runCommand "wlogout"
        {
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
