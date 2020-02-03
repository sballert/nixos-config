{ readConfig }: self: super: let

  inherit (super) stdenv fetchFromGitHub;

in rec {
  slock = super.slock.override {
    conf = readConfig "slock.h";
  };
  st = super.st.override {
    conf = readConfig "st.h";
  };
  xlogout = stdenv.mkDerivation {
    name = "xlogout";
    unpackPhase = ":";
    installPhase = ''
      install -m755 -D ${./../scripts/xlogout.sh} $out/bin/xlogout
    '';
  };
  session-menu = stdenv.mkDerivation {
    name = "session-menu";
    buildInputs = [ self.rofi xlogout ];
    unpackPhase = ":";
    installPhase = ''
      install -m755 -D ${./../scripts/session-menu.sh} $out/bin/session-menu
    '';
  };
  toggle-touchpad = stdenv.mkDerivation {
    name = "toggle-touchpad";
    buildInputs = [ self.xorg.xinput ];
    unpackPhase = ":";
    installPhase = ''
      install -m755 -D ${./../scripts/toggle-touchpad.sh} $out/bin/toggle-touchpad
    '';
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
