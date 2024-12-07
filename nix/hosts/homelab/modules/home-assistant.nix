{
  pkgs,
  config,
  ...
}: {
  services.home-assistant = {
    enable = true;

    extraComponents = [
      "xiaomi_ble"
      "zha"
      "mqtt"
      "samsungtv"
    ];
    extraPackages = ps:
      with ps; [
        getmac
        pyatv
        samsungctl
        samsungtvws
      ];
    customComponents = [
      (pkgs.callPackage ../../../packages/home-assistant/custom_components/samsungtv-tizen.nix {})
    ];

    # Your configuration.yaml as a Nix attribute set.
    config = {
      default_config = {};
      homeassistant = {
        internal_url = "https://home.heyzec.dedyn.io";
        external_url = "https://home.heyzec.dedyn.io";
      };
      http = {
        # Setup for reverse proxy to properly accept connections
        use_x_forwarded_for = true;
        trusted_proxies = ["127.0.0.1" "::1"];
      };

      automation = "!include automations.yaml";
      script = "!include scripts.yaml";
    };
  };

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        acl = ["pattern readwrite #"];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
  };

  services.zigbee2mqtt = {
    enable = true;
    settings = {
      homeassistant = config.services.home-assistant.enable;
      frontend = true;
      serial = {
        adapter = "ember";
      };
    };
  };

  # 8080 is for Zigbee2MQTT frontend
  networking.firewall.allowedTCPPorts = [1883 8123 8080];
  services.caddy.virtualHosts."home.heyzec.dedyn.io".extraConfig = ''
    reverse_proxy * localhost:8123
  '';
}
