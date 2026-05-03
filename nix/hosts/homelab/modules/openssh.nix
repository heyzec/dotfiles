{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      # Only allow login with keys
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };

    # Forward SFTP user to chroot directory
    extraConfig = ''
      Match Group sftponly
        ChrootDirectory /media/backups
        ForceCommand internal-sftp
        AllowTcpForwarding no
    '';
  };
}
