See https://www.haskellforall.com/2023/01/announcing-nixos-rebuild-new-deployment.html

```
nixos-rebuild switch --fast --use-remote-sudo --build-host pi@192.168.1.10 --target-host pi@192.168.1.10 --flake .#default
```

Jan 2024 update:
```
nixos-rebuild switch --fast --use-remote-sudo --build-host pi@heyzec.mooo.com --target-host pi@heyzec.mooo.com --flake .#default --verbose
```
by building on the host, no ssh issues will occur

If we want to build on laptop and then deploy, will have askpass problem
- https://discourse.nixos.org/t/remote-nixos-rebuild-sudo-askpass-problem/28830/22

Also check this out: https://mtlynch.io/nixos-pi4/configuration.nix
- https://www.reddit.com/r/NixOS/comments/1531nyc/installing_nixos_on_raspberry_pi_4/
