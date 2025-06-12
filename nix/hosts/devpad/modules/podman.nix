{pkgs, ...}: {
  # Podman, a drop-in replacement for Docker
  virtualisation.podman = {
    enable = true;
    dockerCompat = true; # Alias `docker` to `podman`
  };

  environment.systemPackages = with pkgs; [
    podman-compose # Replacement for docker-compose
  ];
}
