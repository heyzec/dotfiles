cd "$(dirname "$0")"

ln -s $(realpath .zshrc) ~/.zshrc
ln -s $(realpath .zshenv) ~/.zshenv


cd plugins
git clone https://github.com/simnalamburt/zsh-expand-all
git clone https://github.com/zsh-users/zsh-syntax-highlighting
git clone https://github.com/agkozak/zsh-z
