self: super: let

  inherit (super) stdenv fetchFromGitHub;

in rec {
  slock = super.slock.override {
    conf = builtins.readFile ../config/slock.h;
  };
  st = super.st.override {
    conf = builtins.readFile ../config/st.h;
  };
  gruvbox-rofi = stdenv.mkDerivation {
    name = "gruvbox-rofi";
    src = fetchFromGitHub {
      owner = "bardisty";
      repo = "gruvbox-rofi";
      rev = "0b4cf703087e2150968826b7508cf119437eba7a";
      sha256 = "18rkm03p08bjkgiqh599pcvyqxmwldza600pq3sinmpk4sv4s1cw";
    };
    installPhase = ''
      install -d $out
      install -m755 -D $src/*.rasi $out
    '';
  };
  xrandr-util = stdenv.mkDerivation {
    name = "xrandr-util";
    buildInputs = [ self.xorg.xrandr ];
    unpackPhase = ":";
    installPhase = ''
      install -m755 -D ${./../scripts/xrandr-util.sh} $out/bin/xrandr-util
    '';
  };
  nix-util = stdenv.mkDerivation {
    name = "nix-util";
    unpackPhase = ":";
    installPhase = ''
      install -m755 -D ${./../scripts/nix-util.sh} $out/bin/nix-util
    '';
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
