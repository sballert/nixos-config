{ stdenv, lib, makeWrapper, libnotify }:

stdenv.mkDerivation {
  name = "toggle-screen-locker";
  buildInputs = [ makeWrapper ];
  unpackPhase = ":";
  installPhase = ''
    install -m755 -D ${./toggle-screen-locker.sh} $out/bin/toggle-screen-locker
    wrapProgram $out/bin/toggle-screen-locker \
    --prefix PATH : "${lib.makeBinPath [ libnotify ]}"
  '';
}
