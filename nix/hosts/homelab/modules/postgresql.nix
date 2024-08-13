{ lib, ... }:
{
  lib.heyzec.postgresql = {
    enable = true;
    # TODO: don't hardcode
    username = "pi";
  };
}

