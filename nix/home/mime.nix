{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain" = ["org.gnome.TextEditor.desktop"];
      "inode/directory" = ["thunar.desktop"];
      "text/x-uri" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "x-scheme-handler/mailto" = ["firefox.desktop"];
      "image/*" = ["qimgv.desktop"];
      "image/png" = ["qimgv.desktop"];
      "image/jpeg" = ["qimgv.desktop"];
      "video/*" = ["vlc.desktop"];
      "application/pdf" = ["atril.desktop"];
      "application/x-archive" = [ "gnome-file-roller.desktop" ];
    };
  };
  xdg.configFile."mimeapps.list".force = true;
}

