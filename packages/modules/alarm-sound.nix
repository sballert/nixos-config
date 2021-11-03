{ lib, ... }:

with lib;

{

  imports = [];

  options.alarm-sound = {
    wavUrl = mkOption {
      type = types.str;
      default = "http://jerryching.spdns.de/Software/Chat/ICQ/Sounds/Original%20Sounds/Message.wav";
      description = ''
        Defines the sound url
      '';
    };
  };
}
