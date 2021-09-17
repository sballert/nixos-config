{}: let
  configDir = ./../config;

  wallpaper = builtins.fetchurl https://s3.amazonaws.com/psiu/wallpapers/heic1209a/heic1209a_desktop.jpg;

  pathToConfig = conf: configDir + "/${conf}";

  readConfig = conf: builtins.readFile (configDir + "/${conf}");

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      (import ./../packages/overlays/mypackages.nix)
      (import ./../packages/overlays/overwrites.nix)
      (import (builtins.fetchTarball {
        url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      }))
    ];
  };

in {
  inherit configDir wallpaper pathToConfig readConfig nixpkgs;
}
