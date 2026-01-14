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

## Private repository
A small part of the configuration is stored in a private repository. This repository is referred to in the flake inputs as `private`.
Even without this input, the configurations can still be built as there are conditional checks.

For public users (you!), to prevent Nix from attempting and failing to fetch this input, a Git filter is used to hide this input. For reference, the filters are as follows:
```
# .git/config
[filter "unhide-flake-nix"]
	smudge = "sed '0,/# private.url/s//private.url/'"
	clean = "sed '0,/private.url/s//# private.url/'"
[filter "unhide-flake-lock"]
	smudge = "jq '(.nodes |= with_entries(if .key == \"private-hidden\" then .key = \"private\" else . end)) | (.nodes.root.inputs |= . + {private: \"private\"})'"
	clean = "jq '(.nodes |= with_entries(if .key == \"private\" then .key = \"private-hidden\" else . end)) | (.nodes.root.inputs |= del(.private))'"
```
