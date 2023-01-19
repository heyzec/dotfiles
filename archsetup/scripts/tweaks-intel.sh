# Use Intel drivers
# (this fixes screen tearing)
# https://wiki.archlinux.org/title/Intel_graphics#Xorg_configuration

_ xf86-video-intel    : Xorg intel drivers
sudo tee /etc/X11/xorg.conf.d/20-intel.conf << END > /dev/null
Section "Device"
    Identifier    "Intel Graphics"
    Driver        "intel"
    Option        "TearFree"  "true"
EndSection
END

# Use hardware video acceleration
# https://wiki.archlinux.org/title/Hardware_video_acceleration#Intel
_ intel-media-driver : driver for intel

# Microcode
# May need manual config of boot loader to use microcode 
# https://wiki.archlinux.org/title/Microcode#Early_loading
_ intel-ucode   : microcode patches for CPU
