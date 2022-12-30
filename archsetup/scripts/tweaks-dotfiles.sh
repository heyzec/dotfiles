# Remove the default config files created
rm -rf ~/.config/i3

git clone --recursive -b next https://github.com/heyzec/dotfiles
(cd dotfiles && bash ./install.sh)

i3-msg restart
