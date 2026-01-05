{
  lib,
  buildNpmPackage,
}:
buildNpmPackage (finalAttrs: {
  pname = "surfingkeys-conf";
  version = "0.0.0";

  src = lib.sourceByRegex ./. [
    "^package.json$"
    "^package-lock.json$"
    "^serve.js$"
  ];

  npmDepsHash = "sha256-mBjEgnanuULzo4HsKGjOwWikvHZAmOhbwykb8R/vtD0=";
  dontNpmBuild = true;

  meta.mainProgram = "serve";
})
