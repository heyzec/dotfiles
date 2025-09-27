{pkgs, ...}: {
  nixpkgs.overlays = [
    (self: super: {
      choose-gui = super.choose-gui.overrideAttrs (old: rec {
        version = "1.5.0";

        src = pkgs.fetchFromGitHub {
          owner = "chipsenkbeil";
          repo = "choose";
          rev = version;
          hash = "sha256-ewXZpP3XmOuV/MA3fK4BwZnNb2jkE727Sse6oAd4HJk=";
        };
      });
    })
  ];
}
