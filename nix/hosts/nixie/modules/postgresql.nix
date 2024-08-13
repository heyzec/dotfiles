{ userSettings, ... }:
let
  username = userSettings.username;
in
{
  heyzec.postgresql = {
    enable = true;
    username = username;
  };
}

