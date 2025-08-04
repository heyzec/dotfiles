darwin:
    sudo darwin-rebuild switch --flake ~/dotfiles#darwin

home:
    home-manager switch --flake ~/dotfiles#darwin

kanata:
    pgrep kanata && sudo launchctl bootout system/org.custom.kanata || true
    sudo kanata --cfg /Users/SP15013/.config/kanata/kanata.kbd

