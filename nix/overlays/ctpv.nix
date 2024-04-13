{
  imports = [
    ((import ./utils.nix).overrideSrc {
      name = "ctpv";
      # See https://github.com/NikitaIvanovV/ctpv/pull/90
      patches = [ ./ctpv.use-polite-flag.diff ];
    })
  ];
}
