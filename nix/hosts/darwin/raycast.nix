{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    raycast
  ];

  launchd.user.agents.raycast = {
    serviceConfig.ProgramArguments =
      [ "/Applications/Nix Apps/Raycast.app/Contents/MacOS/Raycast" ];
    serviceConfig.RunAtLoad = true;
  };
}
