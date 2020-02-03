{ stdenv }:

stdenv.mkDerivation {
  name = "xlogout";
  unpackPhase = ":";
  installPhase = ''
    install -m755 -D ${./xlogout.sh} $out/bin/xlogout
  '';
}
