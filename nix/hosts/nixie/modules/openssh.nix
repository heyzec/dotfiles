{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      # Password authentication: server asks for only a single password, but does not send any specific prompt
      # Keyboard-interactive: server can ask for an arbitrary number of pieces of information (though usually only one)
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
    };
    extraConfig = ''
      # Require both public key AND password to login
      AuthenticationMethods "publickey,password"
    '';
  };
}

