# This fixes screen tearing


_ xf86-video-intel    : Xorg intel drivers
sudo tee /etc/X11/xorg.conf.d/20-intel.conf << END > /dev/null
Section "Device"
    Identifier    "Intel Graphics"
    Driver        "intel"
    Option        "TearFree"  "true"
EndSection
END
