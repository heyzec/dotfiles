{ pkgs, ... }:
{
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ ];
        # My config is added to /etc/keyd/ manually instead of via nix
      };
    };
  };
  environment.systemPackages = with pkgs; [
    # Add keyd to programs too for manpage
    keyd
  ];
}

