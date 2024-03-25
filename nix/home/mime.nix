{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = let
      defaultBrowser = "floorp.desktop";
    in {
      "text/plain" = ["org.gnome.TextEditor.desktop"];
      "inode/directory" = ["thunar.desktop"];
      "text/x-uri" = [defaultBrowser];
      "x-scheme-handler/http" = [defaultBrowser];
      "x-scheme-handler/https" = [defaultBrowser];
      "x-scheme-handler/mailto" = [defaultBrowser];
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

