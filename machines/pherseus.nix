{ config, pkgs, ... }: let

  util = import ./util.nix {};

in with util; {

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
    inherit pkgs nixpkgs lib config;
  };

}
