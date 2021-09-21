{ config, pkgs, lib, ... }: {

  users.users.sballert = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "adbusers"
    ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  services.xserver.displayManager.lightdm.greeters.mini.user = "sballert";

  home-manager.users.sballert = import ./../home {
    inherit pkgs lib config;
  };

}
