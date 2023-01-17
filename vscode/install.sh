cd "$(dirname "$0")"

ln -s $(realpath settings.json) "$HOME/.config/Code/User/"
ln -s $(realpath keybindings.json) "$HOME/.config/Code/User/keybindings.json"
