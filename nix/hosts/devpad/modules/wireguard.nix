{
  inputs,
  config,
  pkgs,
  hasPrivate,
  ...
}:
if hasPrivate
then {
  # Define connection with NetworkManager
  environment.etc."NetworkManager/system-connections/wg0.nmconnection" = {
    mode = "600"; # NetworkManager will refuse to load connections that are world-readable
    text = ''
      [connection]
      id=Wireguard to Homelab
      type=wireguard
      interface-name=wg0
      autoconnect=false

      [ipv4]
      method=manual
      address1=192.168.2.1/32

      [wireguard]
      listen-port=51820
      private-key=thisisafakekeythisisafakekeyOPFHKrs5PKsRIcE=

      ${inputs.private.devpad.attributes.wireguard.peers}
    '';
    # Set peers' allowed-ips=0.0.0.0/0;
  };

  # Load actual private key from agenix file on connection up
  environment.etc."NetworkManager/dispatcher.d/1-wg0-postup".source = pkgs.writeScript "1-wg0-postup" ''
    interface="$1"
    status="$2"

    if [ "$interface" = "wg0" ] && [ "$status" = "up" ]; then
        ${pkgs.wireguard-tools}/bin/wg set wg0 private-key ${config.age.secrets.wireguard.path};
    fi
  '';

  networking.firewall = {
    allowedTCPPorts = [51820];

    # Wireguard handshake will arrive on non-wg0 interface, which rpfilter will block
    extraCommands = ''
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
    '';
    extraStopCommands = ''
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
    '';
  };
}
else {}
