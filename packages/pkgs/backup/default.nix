{ stdenv, rsync }:

stdenv.mkDerivation {
  name = "backup";
  buildInputs = [ rsync ];
  unpackPhase = ":";
  installPhase = ''
    install -m755 -D ${./backup.sh} $out/bin/backup
  '';
}
