{
  xdg.configFile."joplin-plugin-tabs" = {
    source = builtins.fetchurl {
      url = "https://github.com/benji300/joplin-note-tabs/releases/download/v1.4.0/joplin.plugin.note.tabs.jpl";
      sha256 = "1mdw3p8g1sklyj1jicwgxlalvrg4zrrs2aizbrm7bym7lm8b8znv";
    };
    target = "joplin-desktop/plugins/joplin.plugin.note.tabs.jpl";
  };
  xdg.configFile."joplin-plugin-sidebars" = {
    source = builtins.fetchurl {
      url = "https://github.com/joplin/plugins/releases/download/plugins/org.joplinapp.plugins.ToggleSidebars@1.0.3.jpl";
      name = "org.joplinapp.plugins.ToggleSidebars.jpl";
      sha256 = "12clq50vplg8c3mnaybh861ap2bawlpazrzbnq10q5izswvl1x8g";
    };
    target = "joplin-desktop/plugins/org.joplinapp.plugins.ToggleSidebars.jpl";
  };
}
