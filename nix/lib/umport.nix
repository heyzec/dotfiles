# Inspired by https://gist.github.com/yunfachi/6c073cc6edc18f78cfc60bb9bb3f7143
{ lib }:
{ path
, exclude ? [ ]
}:
let
  filenames = builtins.attrNames (builtins.readDir path);
  filtered = builtins.filter
    (
      filename:
      lib.strings.hasSuffix ".nix" filename &&
      ! lib.strings.hasSuffix ".crypt.nix" filename &&
      filename != "default.nix" &&
      ! builtins.elem filename exclude
    )
    filenames;
  paths = builtins.map (filename: path + "/${filename}") filtered;
in
paths

