{ config, lib, pkgs, ... }:
let
  format = pkgs.formats.php { };
in
{
  services.caddy = {
    enable = true;
    logFormat = ''
      level DEBUG
    '';

    virtualHosts."http://localhost".extraConfig = ''
      handle_path /simplesaml* {
        root * ${config.services.simplesamlphp.sa.libDir}/www

        # This is `php_fastcgi unix//run/phpfpm/app.sock` but expanded and tweaked
        route {
          # Add trailing slash for directory requests
          @canonicalPath {
            file {path}/index.php
            not path */
          }
          redir @canonicalPath {http.request.orig_uri.path}/ 308

          # If the requested file does not exist, try index files
          @indexFiles file {
            try_files {path} {path}/index.php
            split_path .php
          }
          rewrite @indexFiles {file_match.relative}

          # Proxy PHP files to the FastCGI responder
          @phpFiles path *.php
          reverse_proxy @phpFiles unix//run/phpfpm/app.sock {
            transport fastcgi {
              split .php
            }
          }
        }
      }
    '';
  };

  services.phpfpm.settings = {
    "log_level" = "debug";
  };
  services.phpfpm.pools."app" = {
    user = "heyzec";
    group = "nobody";
    settings = {
      "listen.owner" = "caddy";
      "pm" = "dynamic";
      "pm.max_children" = 32;
      "pm.max_requests" = 500;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 2;
      "pm.max_spare_servers" = 5;
      "php_admin_value[error_log]" = "stderr";
      "php_admin_flag[log_errors]" = true;
      "catch_workers_output" = true;
    };
    phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
  };

  services.simplesamlphp.sa = {
    phpfpmPool = "app";
    settings = {
      baseurlpath = lib.mkDefault "http://localhost/simplesaml/";
      "auth.adminpassword" = "$2y$10$UQC8/1D6QyAjaR5rgSebXuoRCQhj5biaa/u4of7q/8QNpMJoERiji";
      "secretsalt" = "68XVmMjQqJc6dBk+qIfJTeVKXCFMWl6WG7tLbz9cloM=";
      "logging.handler" = "syslog";
      "technicalcontact_name" = "Administrator";
      "technicalcontact_email"= "na@example.org";
      "timezone"= "Asia/Singapore";

      # Enable IDP mode
      "enable.saml20-idp" = true;
      "module.enable" = {
        "exampleauth" = true;
      };
      "certdir" = "/srv/cert";
      "metadatadir" = "/srv/metadata";
    };
    authSources = {
      admin = [ "core:AdminPassword" ];
      "example-userpass" = format.lib.mkMixedArray [ "exampleauth:UserPass" ] {
        "user:password" = {
          uid = [ "user" ];
          cn = [ "user" ];
          mail = [ "user@nixos.org" ];
        };
      };
    };
  };
}
