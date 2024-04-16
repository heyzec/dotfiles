{
  hardware = {
    raspberry-pi."4" = {
        apply-overlays-dtmerge.enable = true;
        fkms-3d.enable = true;  # Enable GPU acceleration (a must for X!)
    };
    # deviceTree = {
    #   enable = true;
    #   filter = "*rpi-4-*.dtb";
    # };
  };
}
