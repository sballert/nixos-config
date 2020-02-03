{ readConfig }: self: super: let

  inherit (super) stdenv fetchFromGitHub;

in rec {
  slock = super.slock.override {
    conf = readConfig "slock.h";
  };
  st = super.st.override {
    conf = readConfig "st.h";
  };
  bluetoothctl-menu = stdenv.mkDerivation {
    name = "bluetoothctl-menu";
    buildInputs = [ self.makeWrapper  ];
    unpackPhase = ":";
    installPhase = ''
      install -m755 -D ${./../scripts/bluetoothctl-menu.sh} $out/bin/bluetoothctl-menu
      wrapProgram $out/bin/bluetoothctl-menu \
      --prefix PATH : "${stdenv.lib.makeBinPath [ self.libnotify
      self.rofi
      self.bluez
      self.gawk
      self.gnugrep ]}"
    '';
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
