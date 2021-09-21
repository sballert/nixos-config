{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.boot.v4l2loopback;
in {
  imports = [
  ];

  options.boot.v4l2loopback = {

    # https://github.com/umlaeute/v4l2loopback

    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, NixOS will boot with v4l2loopback device.
      '';
    };

    videoNr = mkOption {
      type = types.str;
      default = "9";
      description = ''
        Defines the number of the device (e.g. /dev/video9)
      '';
    };

    cardLabel = mkOption {
      type = types.str;
      default = "v4l2";
      description = ''
        Defines the name of the device.
      '';
    };

  };

  config = {
    boot = mkIf cfg.enable {
      extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
      kernelModules =  [ "v4l2loopback" ];
      extraModprobeConfig = ''
        options v4l2loopback exclusive_caps=1 video_nr=${cfg.videoNr} card_label=${cfg.cardLabel}
      '';
    };
  };
}
