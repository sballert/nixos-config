{ readConfig }: self: super: let

  inherit (super) stdenv fetchFromGitHub;

in rec {
  slock = super.slock.override {
    conf = readConfig "slock.h";
  };
  st = super.st.override {
    conf = readConfig "st.h";
  };
  backup = stdenv.mkDerivation {
    name = "backup";
    buildInputs = [ self.rsync ];
    unpackPhase = ":";
    installPhase = ''
      install -m755 -D ${./../scripts/backup.sh} $out/bin/backup
    '';
  };
}
