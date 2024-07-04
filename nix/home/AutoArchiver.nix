{ lib, pkgs, userSettings, ... }:
let
  folders = [
    "/home/${userSettings.username}/Downloads"
    "/home/${userSettings.username}/Pictures/Screenshots"
  ];
  AutoArchiver = pkgs.writeShellScript "AutoArchiver" ''
    # AUTOARCHIVER
    # Automatically archives files in folder. Sorts them into folders by months. Great for the Downloads folder.
    # Requires cronjob to run this script on every @reboot. Example:
    # @reboot /path/to/AutoArchiver.sh ~/Downloads
    # @reboot /path/to/AutoArchiver.sh ~/Pictures/Screenshots


    cd "$1" || exit 1

    folder="Archived/$(date +'%Y-%m')"
    mkdir "$folder" 2>/dev/null

    # https://unix.stackexchange.com/questions/127712/merging-folders-with-mv
    find . -maxdepth 1 -mindepth 1 \
        ! -name 'Archived' \
        -ctime +1 \
        -exec mv "{}" "$folder/" \;
  '';
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
    (folder: "${AutoArchiver} ${folder}")
    folders;
}
