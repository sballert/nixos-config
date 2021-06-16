{ stdenv, xorg, lib, makeWrapper, libnotify }:

stdenv.mkDerivation {
  name = "toggle-touchpad";
  buildInputs = [ xorg.xinput makeWrapper ];
  unpackPhase = ":";
  installPhase = ''
    install -m755 -D ${./toggle-touchpad.sh} $out/bin/toggle-touchpad
    wrapProgram $out/bin/toggle-touchpad \
    --prefix PATH : "${lib.makeBinPath [ libnotify ]}"
  '';
}
