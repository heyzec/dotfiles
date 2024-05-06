{ pkgs, ... }:
let
in
{
  systemd.services = {
    "notify-failure@" = {
      description = "Send notification for %i";
      serviceConfig.Type = "oneshot";
      script = /* bash */ ''
        # notify-send "A failure has occurred" "$1"
      '';
      scriptArgs = "%i";
    };
  };
}
