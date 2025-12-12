{
  pkgs,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:
buildHomeAssistantComponent rec {
  owner = "ollo69";
  domain = "samsungtv_smart";
  version = "0.13.4";

  src = fetchFromGitHub {
    owner = "ollo69";
    repo = "ha-samsungtv-smart";
    rev = "v${version}";
    hash = "sha256-z6mIWuMQgFqo6WgnMCty1ur/iSxGTXok8snwUtRDkU8=";
  };

  propagatedBuildInputs = with pkgs.home-assistant.python.pkgs; [
    numpy
    websocket-client
    wakeonlan
    aiofiles
    casttube
  ];
}
