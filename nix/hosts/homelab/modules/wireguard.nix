{
  inputs,
  config,
  pkgs,
  ...
}:
if inputs.private.hasPrivate
then let
  # The port that WireGuard listens to - recommended that this be changed from default
  wireguardPort = 51820;
  # Address of this host ("server"-ish) within the VPN subnet
  ipv4Address = "192.168.2.253/24";
in {
  # Enable NAT
  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "eth0";
    internalInterfaces = ["wg0"];
  };
  # Open ports in the firewall
  networking.firewall = {
    allowedTCPPorts = [53];
    allowedUDPPorts = [53 wireguardPort];
  };

  networking.wg-quick.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    "wg0" = {
      # Determines the IP/IPv6 address and subnet of the client's end of the tunnel interface
      address = [
        ipv4Address
        /*
        "fdc9:281f:04d7:9ee9::1/64"
        */
      ];
      listenPort = wireguardPort;
      privateKeyFile = config.age.secrets.wireguard.path; # server's private key

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      postUp = ''
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${ipv4Address} -o eth0 -j MASQUERADE
        # ${pkgs.iptables}/bin/ip6tables -A FORWARD -i wg0 -j ACCEPT
        # ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o eth0 -j MASQUERADE
      '';

      # Undo the above
      preDown = ''
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${ipv4Address} -o eth0 -j MASQUERADE
        # ${pkgs.iptables}/bin/ip6tables -D FORWARD -i wg0 -j ACCEPT
        # ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o eth0 -j MASQUERADE
      '';

      # Each peer to be specified on a different subnet
      # https://superuser.com/questions/1670154/same-allowedips-for-multiple-peers-with-wireguard
      peers = inputs.private.homelab.attributes.wireguard.peers;
    };
  };
}
else {}
