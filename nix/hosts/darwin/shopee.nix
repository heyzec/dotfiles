{pkgs, ...}: {
  launchd = {
    agents = {
      spex-socket = {
        command = "${pkgs.socat}/bin/socat -d -d -d UNIX-LISTEN:/tmp/spex.sock,reuseaddr,fork TCP:agent-tcp.spex.test.shopee.io:9299";

        serviceConfig = {
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "/tmp/spex.log";
          StandardErrorPath = "/tmp/spex.log";
        };
      };
    };
  };
}
