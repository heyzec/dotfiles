# Power management module with sane defaults. Features:
# - Configurable durations to blank screen and suspend-then-hibernate after idle
# - Lock screen after waking up from idle timeout
# - Enable suspend-then-hibernate and patch wlogout to use it
#
# It serves as a wrapper over hypridle, wlogout and systemd-sleep.
# hypridle must still be daemonised manually with config at /etc/hypr/hypridle.conf (this is non-standard)
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.heyzec.power;
in {
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

    environment.etc =
      if !cfg.enable
      then {}
      else {
        # Refer to https://github.com/hyprwm/hypridle/issues/176 for file location
        "xdg/hypr/hypridle.conf" = {
          text =
            ''
              general {
                after_sleep_cmd = ${cfg.commandLockScreen};
              }
            ''
            + (
              if cfg.blankAfter == null
              then ""
              else
                (
                  if cfg.commandBlankScreen == null || cfg.commandUnblankScreen == null
                  then abort "commandBlankScreen and commandUnblankScreen must be specified if blankAfter is specified"
                  else ''
                    listener {
                      timeout = ${toString cfg.blankAfter}
                      on-timeout = ${cfg.commandBlankScreen}
                      on-resume = ${cfg.commandUnblankScreen}
                    }
                  ''
                )
            )
            + (
              if cfg.sleepAfter == null
              then ""
              else ''
                listener {
                  timeout = ${toString cfg.sleepAfter}
                  on-timeout = systemctl suspend-then-hibernate
                }
              ''
            );
        };
      };

    # Added to [Sleep] section
    systemd.sleep.extraConfig =
      if cfg.enable && cfg.hibernateAfter != null
      then ''
        HibernateDelaySec=${builtins.toString cfg.hibernateAfter}
      ''
      else "";

    environment.systemPackages = [
      # wlogout, patched with our commands
      # We cannot use pkgs.runCommand and copy the original binary because
      # postPatch has overriden the etc config files to the original $out
      (pkgs.wlogout.overrideAttrs (oldAttrs: {
        postInstall = ''
          substituteInPlace $out/etc/wlogout/layout \
            --replace "systemctl suspend" "systemctl suspend-then-hibernate"

          # Add sleep to wait for wlogout to fade out first, otherwise hyprlock will screenshot it
          # TODO: Try to make swaylock respond to loginctl instead
          substituteInPlace $out/etc/wlogout/layout \
            --replace "loginctl lock-session" "sh -c 'sleep 0.5 && ${cfg.commandLockScreen}'"
        '';
      }))
    ];
  };
}
