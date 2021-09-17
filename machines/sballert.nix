{ config, pkgs, ... }: let

  util = import ./util.nix {};

in with util; {

  users.users.sballert = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "adbusers"
    ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  home-manager.users.sballert = import ./../home {
    inherit pkgs nixpkgs wallpaper pathToConfig readConfig lib;
  };

}
