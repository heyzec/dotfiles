cd "$(dirname "$0")"

ln -s $(realpath .zshrc) ~/.zshrc
ln -s $(realpath .zshenv) ~/.zshenv


cd plugins
