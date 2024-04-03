# NixOS

Here lies my NixOS configs. To build a virtual machine and test it out, do this:

1. `cd` into this directory

1. Build the NixOS VM. A symlink `result` will be created.
    ```
    nixos-rebuild build-vm --flake .#nixos-vm --impure
    ```
    _--impure is needed for now, to fix next time_

1. Start the NixOS VM. On first boot, a QEMU image `.qcow` file will be created.
    ```
    result/bin/run-*-vm
    ```
