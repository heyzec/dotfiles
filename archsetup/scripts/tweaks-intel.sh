# This fixes screen tearing


_ xf86-video-intel    : Xorg intel drivers

cat > /etc/X11/xorg.conf.d/20-intel.conf << END
Section "Device"
    Identifier    "Intel Graphics"
    Driver        "intel"
    Option        "TearFree"  "true"
EndSection
END
