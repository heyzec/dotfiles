# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  inputs,
  pkgs,
  hasPrivate,
  ...
}: {
  imports =
    [
      ./hardware
      ./modules
    ]
    ++ (
      if hasPrivate
      then [
        inputs.private.devpad.modules
        inputs.private.devpad.secrets
      ]
      else []
    );

  programs = {
    dconf.enable = true;
  };

  virtualisation = {
    libvirtd.enable = true;
  };

  # Add additional documentations
  documentation.dev.enable = true; # Targeted at developers
  environment.systemPackages = with pkgs; [
    man-pages #     # Linux man pages
    man-pages-posix # POSIX man pages
  ];

  # NixOS System Version (Do not touch!!)
  system.stateVersion = "23.05";

  hardware.logitech.wireless.enable = true;

  system.activationScripts = {
    debug = {
      text = ''
        echo debug value 1>&2
        cat <<EOF 1>&2
        ${config.services.udev.extraRules}
        EOF
      '';
    };
  };

  services.gnome.evolution-data-server.enable = true;
  # optional to use google/nextcloud calendar
  services.gnome.gnome-online-accounts.enable = true;

  services.udev.extraRules = ''
    ACTION!="add|remove|bind", GOTO="hid_bpf_end"
    SUBSYSTEM!="hid", GOTO="hid_bpf_end"

    # We lookup the hwdb during bind to set the property, but we don't do anything else
    IMPORT{builtin}="hwdb --subsystem=hid --lookup-prefix=hid-bpf:"
    ACTION=="add", ENV{.HID_BPF}=="1", RUN{program}+="/nix/store/05zrbd3x3had58hbwhqqs2cqg8639b8a-udev-hid-bpf-4640bddff9deaa47179566e214955f40c0de6960/bin/udev-hid-bpf add $sys$devpath"
    ACTION=="remove", ENV{.HID_BPF}=="1", RUN{program}+="/nix/store/05zrbd3x3had58hbwhqqs2cqg8639b8a-udev-hid-bpf-4640bddff9deaa47179566e214955f40c0de6960/bin/udev-hid-bpf remove $sys$devpath"

    LABEL="hid_bpf_end"
  '';

  services.udev.extraHwdb = ''
    # This file is generated and will be overwritten on updates. Do not edit

    hid-bpf:hid:b0003g*v0000046Dp0000C626
      HID_BPF_T_000=0009-Logitech__SpaceNavigator.bpf.o
      .HID_BPF=1

    hid-bpf:hid:b0003g*v0000046Dp0000C626
      HID_BPF_T_001=0010-Logitech__SpaceNavigator.bpf.o
      .HID_BPF=1

    hid-bpf:hid:b0018g0004v000006CBp0000CDE6
      HID_BPF_T_002=0011-Synaptics__DLL0945.bpf.o
      .HID_BPF=1

    hid-bpf:hid:b0018g0004v000006CBp0000CE26
      HID_BPF_T_003=0011-Synaptics__DLL0945.bpf.o
      .HID_BPF=1

    hid-bpf:hid:b0003g*v0000172Fp00000505
      HID_BPF_T_004=0009-WALTOP__Batteryless-Tablet.bpf.o
      .HID_BPF=1

    hid-bpf:hid:b0003g*v0000172Fp00000505
      HID_BPF_T_005=0010-WALTOP__Batteryless-Tablet.bpf.o
      .HID_BPF=1

    hid-bpf:hid:b0003g0001v0000256Cp00000066
      HID_BPF_T_006=0019-Huion__Inspiroy-2-S.bpf.o
      .HID_BPF=1

    hid-bpf:hid:b0003g0001v0000256Cp00000066
      HID_BPF_T_007=0020-Huion__Inspiroy-2-S.bpf.o
      .HID_BPF=1

    hid-bpf:hid:b0003g0001v0000256Cp00000067
      HID_BPF_T_008=0009-Huion__Inspiroy-2-M.bpf.o
      .HID_BPF=1

    hid-bpf:hid:b0003g0001v0000256Cp00000067
      HID_BPF_T_009=0010-Huion__Inspiroy-2-M.bpf.o
      .HID_BPF=1

    hid-bpf:hid:b0003g0004v0000256Cp0000006B
      HID_BPF_T_010=0029-Huion__Kamvas-Pro-19.bpf.o
      .HID_BPF=1

    hid-bpf:hid:b0003g0004v0000256Cp0000006B
      HID_BPF_T_011=0030-Huion__Kamvas-Pro-19.bpf.o
      .HID_BPF=1

    hid-bpf:hid:b0003g0004v0000256Cp0000006C
      HID_BPF_T_012=0029-Huion__Kamvas-Pro-19.bpf.o
      .HID_BPF=1

    hid-bpf:hid:b0003g0004v0000256Cp0000006C
      HID_BPF_T_013=0030-Huion__Kamvas-Pro-19.bpf.o
      .HID_BPF=1

    hid-bpf:hid:b0003g*v0000256Cp00002008
      HID_BPF_T_014=0009-Huion__Kamvas13Gen3.bpf.o
      .HID_BPF=1

    hid-bpf:hid:b0003g*v0000256Cp00002008
      HID_BPF_T_015=0010-Huion__Kamvas13Gen3.bpf.o
      .HID_BPF=1

    hid-bpf:hid:b0018g0004v000027C6p00000D42
      HID_BPF_T_016=0010-Dell__DELL0A78.bpf.o
      .HID_BPF=1

    hid-bpf:hid:b0003g0001v000028BDp00000947
      HID_BPF_T_017=0009-XPPen__Deco01V3.bpf.o
      .HID_BPF=1

    hid-bpf:hid:b0003g0001v000028BDp00000947
      HID_BPF_T_018=0010-XPPen__Deco01V3.bpf.o
      .HID_BPF=1
  '';
}
