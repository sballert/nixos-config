{
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
}
