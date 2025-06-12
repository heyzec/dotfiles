# Non-idiomatic configurations in NixOS
{pkgs, ...}: {
  # AppImages, runnable with `appimage-run`
  programs.appimage = {
    enable = true;
    binfmt = true; # Allow invoking AppImages directly by using appimage-run as interpreter
  };

  # Flatpaks
  services.flatpak.enable = true;

  # Run dynamically linked executables
  programs.nix-ld = {
    enable = true;
    libraries = [
      # If needed, add libraries here
    ];
  };

  environment.systemPackages = [
    # Define a FHS-compatible sandbox, available as `fhs`
    (pkgs.buildFHSEnv
      (
        # Sane defaults of libraries to make available
        pkgs.appimageTools.defaultFhsEnvArgs
        // {
          name = "fhs";
          runScript = "$SHELL";
        }
      ))

    # Run another linux distribution in a container
    pkgs.distrobox
  ];
}
