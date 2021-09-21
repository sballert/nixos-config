{}: let
  wallpaper = builtins.fetchurl https://s3.amazonaws.com/psiu/wallpapers/heic1209a/heic1209a_desktop.jpg;

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      (pkgs: _: { my = (import ./../packages { inherit pkgs; }); })
      (import ./../packages/overlays/overwrites.nix)
      (import ./../packages/overlays/nur.nix)
      (import (builtins.fetchTarball {
        url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      }))
    ];
  };

in {
  inherit wallpaper nixpkgs;
}
