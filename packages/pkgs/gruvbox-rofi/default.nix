{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
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
}
