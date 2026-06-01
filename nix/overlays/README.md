# Overlays

Overlays are a mechanism to customise nixpkgs. In this directory, every Nix file is an overlay. An overlay is a function that takes in `final` and `prev` as arguments.

Common usage patterns:

**Override src**

```
final: prev: let
  name = "<package-name>";
in {
  ${name} = prev.${name}.overrideAttrs (finalAttrs: prevAttrs: {
    src = prevAttrs.src.override {
      owner = "...";
      repo = "...";
      rev = "...";  # commonly "v${version}"
      hash = "...";
    };
  });
}
```

**Patch outputs of derivation**

```
final: prev: let
  name = "<package-name>";
in {
  ${name} = prev.${name}.overrideAttrs (finalAttrs: prevAttrs: {
    postInstall = ''
      ...
    '';
  });
}
```
See thunar.nix for an example of using `symlinkJoin` for patching without rebuilding.

**Override src when using buildNpmPackage**
It is likely that you will need to update the hash for the npm dependencies.

However, since `buildNpmPackage` is a wrapper around `mkDerivation`, and `overrideAttrs`
only works for `mkDerivation`, it is too late to change `npmDepsHash`.

Instead, we need to `npmDeps` directly. See `overlays/bruno.nix` for an example of how to do this.
