# use previous version until https://github.com/rvaiya/keyd/issues/1251 fixed
final: prev: let
  name = "keyd";
in {
  ${name} = prev.${name}.overrideAttrs (finalAttrs: prevAttrs: {
    version = "2.5.0";

    src = prevAttrs.src.override {
      rev = "822c686e741037a1912c781ae143d8c454257fbb";
      hash = "sha256-8FbnJsaVKuPPHQ6QQM6OFl3XtBiGsvjsPsbiVHeL6zQ=";
    };
  });
}
