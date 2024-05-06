{ pkgs, ... }:
let
  brevo-email = (import ./notify-failure.crypt.nix).brevo-email;
  sender-email = (import ./notify-failure.crypt.nix).sender-email;
  recipient-email = (import ./notify-failure.crypt.nix).recipient-email;
  noreply-email = (import ./notify-failure.crypt.nix).noreply-email;
  sftp-key = (import ./notify-failure.crypt.nix).sftp-key;
in
{
  programs.msmtp = {
    enable = true;

    # Set default values for all following accounts.
    defaults = {
      auth = "on";
      tls = "on";
      tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
      aliases = "/etc/aliases";
    };

    accounts."brevo" = {
      auth = true;
      host = "smtp-relay.brevo.com";
      port = 587;
      from = sender-email;
      user = brevo-email;
      password = sftp-key;
    };

    # Set a default account
    extraConfig = ''
      account default: brevo
    '';
  };

  environment.etc = {
    "aliases" = {
      text = ''
        admin: ${recipient-email}
      '';
      mode = "0644";
    };
  };


  systemd.services = {
    "notify-failure@" = {
      description = "Send email for %i to admin";
      serviceConfig.Type = "oneshot";
      script = /* bash */ ''
        ${pkgs.msmtp}/bin/sendmail admin <<EOF
        To: ${recipient-email}
        Reply-To: ${noreply-email}
        Subject: Homelab Error - $1

        $(systemctl status --full "$1")

        EOF
      '';
      scriptArgs = "%i";
    };
  };
}
