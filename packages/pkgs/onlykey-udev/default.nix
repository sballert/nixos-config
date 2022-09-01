{ stdenv, fetchurl }: let

  file = fetchurl {
    url = "https://raw.githubusercontent.com/trustcrypto/trustcrypto.github.io/pages/49-onlykey.rules";
    sha512 = "2s99masblmw1lb38dmjki6nka028f32w9z9ix0xi9k7bk6a1hcdfmfxsmgf9fha8cdpvnsn14lshjwjzibnph23d3zsysivcp3cr0y2";
  };

in stdenv.mkDerivation {
  name = "onlykey-udev";
  version = "20210908";

  src = file;

  unpackPhase = ":";

  installPhase = ''
    install -D ${file} $out/lib/udev/rules.d/49-onlykey.rules
  '';
}
# { stdenv }:trustcrypto/trustcrypto.github.io
