{ stdenv, rofi, my }:

stdenv.mkDerivation {
  name = "session-menu";
  buildInputs = [ rofi my.xlogout ];
  unpackPhase = ":";
  installPhase = ''
    install -m755 -D ${./session-menu.sh} $out/bin/session-menu
  '';
}
