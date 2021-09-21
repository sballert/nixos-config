{
  config = {
    allowUnfree = true;
  };
  overlays = [
    (pkgs: _: { my = (import ./../packages { inherit pkgs; }); })

    (import ./../packages {}).overlays.overwrites
    (import ./../packages {}).overlays.nur

    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];
}
