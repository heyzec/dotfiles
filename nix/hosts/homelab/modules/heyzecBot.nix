{ pkgs, ... }:
{
  systemd.services."heyzecBot" = {
    serviceConfig = {
      WorkingDirectory = "/home/pi/heyzecBot";
      ExecStart = let
        python = pkgs.python311.withPackages (ps: with ps; [
          python-dotenv
          requests
          python-telegram-bot
        ]);
      in
        "${python.interpreter} main.py";
    };
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
  };
}
