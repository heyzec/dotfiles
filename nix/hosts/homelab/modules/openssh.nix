{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
    extraConfig = ''
      Match Group sftponly
      ChrootDirectory /media/backups
      ForceCommand internal-sftp
      # PermitTunnel no
      AllowTcpForwarding no
    '';
  };
}

