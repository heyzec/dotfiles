{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    docker
    python3

    plocate

    btop
    btdu
  ];
}
