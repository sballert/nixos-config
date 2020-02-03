{ stdenv, rofi, xlogout }:

stdenv.mkDerivation {
  name = "session-menu";
  buildInputs = [ rofi xlogout ];
  unpackPhase = ":";
  installPhase = ''
    install -m755 -D ${./session-menu.sh} $out/bin/session-menu
  '';
}
