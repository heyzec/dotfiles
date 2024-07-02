{ lib, pkgs, ... }:
let
  folders = [
    "/home/heyzec/Downloads"
    "/home/heyzec/Pictures/Screenshots"
  ];
in
lib.heyzec.timeron {
  name = "AutoArchiver";
  description = "Automatic archiving of folders";
  schedule = "*-*-* 21:58:00";
  addToPath = with pkgs; [
    bash
    busybox
  ];
  script = lib.strings.concatMapStringsSep
    "\n"
    (folder: "/home/heyzec/dotfiles/scripts/AutoArchiver.sh ${folder}")
    folders;
}
