{ stdenv, xorg }:

stdenv.mkDerivation {
  name = "toggle-touchpad";
  buildInputs = [ xorg.xinput ];
  unpackPhase = ":";
  installPhase = ''
    install -m755 -D ${./toggle-touchpad.sh} $out/bin/toggle-touchpad
  '';
}
