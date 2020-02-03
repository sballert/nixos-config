{ stdenv, makeWrapper, libnotify, rofi, bluez, gawk, gnugrep }:

stdenv.mkDerivation {
  name = "bluetoothctl-menu";
  buildInputs = [ makeWrapper  ];
  unpackPhase = ":";
  installPhase = ''
    install -m755 -D ${./bluetoothctl-menu.sh} $out/bin/bluetoothctl-menu
    wrapProgram $out/bin/bluetoothctl-menu \
    --prefix PATH : "${stdenv.lib.makeBinPath [ libnotify
    rofi
    bluez
    gawk
    gnugrep ]}"
  '';
}
