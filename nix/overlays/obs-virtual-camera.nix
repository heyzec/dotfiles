{lib, ...}: {
  imports = [
    (lib.heyzec.overrideSrc {
      name = "obs-studio";
      patches = [./obs-virtual-camera.patch];
    })
  ];
}
