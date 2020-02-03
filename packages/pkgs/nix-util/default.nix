{ stdenv }:

stdenv.mkDerivation {
  name = "nix-util";
  unpackPhase = ":";
  installPhase = ''
    install -m755 -D ${./nix-util.sh} $out/bin/nix-util
  '';
}
