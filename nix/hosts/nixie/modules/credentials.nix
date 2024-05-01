{ pkgs, ... }:
{
  # Use GNOME Keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  environment.systemPackages = with pkgs; [
    # Needed by gnome-keyring-daemon, otherwise GUI will not prompt with error:
    # The name org.gnome.keyring.SystemPrompter was not provided by any .service files
    # See https://github.com/NixOS/nixpkgs/issues/174099#issuecomment-1135967753
    gcr # GNOME crypto services library
  ];
  # Don't let the OpenSSH's SSH agent implementation interfere with GNOME Keyring's
  programs.ssh.startAgent = false;

  programs.seahorse.enable = true;

  programs.gnupg.agent = {
    enable = true;
    # For TUI, use pkgs.pinentry-curses
    pinentryPackage = pkgs.pinentry-gnome3;
  };
}
