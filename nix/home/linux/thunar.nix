{
  # Thunar settings are handled by Xfconf. Use xfconf.settings
  # Run xfconf-query -c thunar -m to see what are the appropriate keys

  xdg.configFile = {
    # This file defines custom actions for Thunar
    # See https://docs.xfce.org/xfce/thunar/custom-actions
    "Thunar/uca.xml" = {
      text = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <actions>
        <action>
            <icon>utilities-terminal</icon>
            <name>Open Terminal Here</name>
            <submenu></submenu>
            <unique-id>1708440471195805-1</unique-id>
            <command>foot -D %f</command>
            <description>Example for a custom action</description>
            <range></range>
            <patterns>*</patterns>
            <startup-notify/>
            <directories/>
        </action>
        </actions>
      '';
    };
  };
}
