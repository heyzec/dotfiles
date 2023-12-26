{
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" "-1234:5678" ];
        settings = {
          "global" = {
            # To ignore tap capslock to Esc if held more than 500 ms
            overload_tap_timeout = 300;
          };
          "main" = {
            # Swap leftalt and meta
            leftalt = "layer(meta)";
            meta = "layer(alt)";

            # Capslock is magical
            capslock = "overload(capslock, esc)";

            # Practise not using arrow keys
            left = "noop";
            down = "noop";
            up = "noop";
            right = "noop";
          };
          "capslock" = {
            h = "left";
            j = "down";
            k = "up";
            l = "right";

            a = "end";
            i = "home";
          };
          "capslock+shift" = {
            h = "C-left";
            j = "pagedown";
            k = "pageup";
            l = "C-right";

            # j = "pagedown";
            # k = "pageup";
            # l = "end";
          };
        };
      };
    };
  };
}
