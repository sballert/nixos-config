{ lib, ... }:

with lib;

{

  imports = [];

  options.wallpaper = {
    imageUrl = mkOption {
      type = types.str;
      default = "https://s3.amazonaws.com/psiu/wallpapers/heic1209a/heic1209a_desktop.jpg";
      description = ''
        Defines the image url
      '';
    };
  };
}
