{ config, ... }:
{
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

