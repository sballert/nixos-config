{ stdenv, xorg }:

stdenv.mkDerivation {
  name = "xrandr-util";
  buildInputs = [ xorg.xrandr ];
  unpackPhase = ":";
  installPhase = ''
    install -m755 -D ${./xrandr-util.sh} $out/bin/xrandr-util
  '';
}
