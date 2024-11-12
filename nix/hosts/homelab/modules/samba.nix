# TODO: debug permissions and visibility of share
{
  services.samba = {
    enable = true;
    openFirewall = true;

    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "security" = "user";
        "hosts allow" = ["192.168.1." "127.0.0.1" "localhost"];
        "hosts deny" = ["0.0.0.0/0"];
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      public = {
        "path" = "/media/shared";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };

  # services.samba-wsdd = {
  #   enable = true;
  #   openFirewall = true;
  # };
}
