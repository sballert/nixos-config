{ config, pkgs, lib, ... }: {

  users.users.pherseus = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "adbusers"
    ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  services.xserver.displayManager.lightdm.greeters.mini.user = "pherseus";

  home-manager.users.pherseus = import ./../home {
    inherit pkgs lib config;
  };

}
