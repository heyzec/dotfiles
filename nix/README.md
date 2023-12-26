# NixOS

Build VM to test it out:
```
nixos-rebuild build-vm --flake dotfiles/nix#nixos-vm --impure
```
--impure is needed for now, to fix next time
