{ readConfig }: self: super: let

  inherit (super) stdenv fetchFromGitHub;

in rec {
  slock = super.slock.override {
    conf = readConfig "slock.h";
  };
  st = super.st.override {
    conf = readConfig "st.h";
  };
}
