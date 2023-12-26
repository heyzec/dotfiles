{ config, ... }:
{
  # SYMLINKED CONFIGS
  xdg.configFile."hyprland" = {
    source = config.lib.file.mkOutOfStoreSymlink /home/heyzec/dotfiles/desktop/hyprland;
    target = "hypr";
  };
  xdg.configFile."waybar" = {
    source = config.lib.file.mkOutOfStoreSymlink /home/heyzec/dotfiles/desktop/waybar;
    target = "waybar";
  };
  xdg.configFile."kanshi" = {
    source = /home/heyzec/dotfiles/desktop/kanshi/config;
    target = "kanshi/config";
  };
  xdg.configFile."starship" = {
    source = /home/heyzec/dotfiles/zsh/starship.toml;
    target = "starship.toml";
  };
  home.file."zsh" = {
    source = /home/heyzec/dotfiles/zsh/.zshenv;
    target = ".zshenv";
  };
  home.file."gitconfig" = {
    source = config.lib.file.mkOutOfStoreSymlink /home/heyzec/dotfiles/git/.gitconfig;
    target = ".gitconfig";
  };

  #TODO: link .config/swhkd as vm is expecting this

  xdg.configFile."vscode-settings" = {
    source = config.lib.file.mkOutOfStoreSymlink /home/heyzec/dotfiles/vscode/keybindings.json;
    target = "Code/User/keybindings.json";
  };
  xdg.configFile."vscode-keybindings" = {
    source = config.lib.file.mkOutOfStoreSymlink /home/heyzec/dotfiles/vscode/settings.json;
    target = "Code/User/settings.json";
  };

  home.file.Documents = {
    source = config.lib.file.mkOutOfStoreSymlink /media/D/Documents;
    target = "Documents";
  };
  home.file.Downloads = {
    source = config.lib.file.mkOutOfStoreSymlink /media/D/Downloads;
    target = "Downloads";
  };
  home.file.Music = {
    source = config.lib.file.mkOutOfStoreSymlink /media/D/Music;
    target = "Music";
  };
  home.file.Pictures = {
    source = config.lib.file.mkOutOfStoreSymlink /media/D/Pictures;
    target = "Pictures";
  };
  home.file.Videos = {
    source = config.lib.file.mkOutOfStoreSymlink /media/D/Videos;
    target = "Videos";
  };
}

