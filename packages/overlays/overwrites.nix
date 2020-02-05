self: super:

{
  slock = super.slock.override {
    conf = builtins.readFile ../../config/slock.h;
  };
  st = super.st.override {
    conf = builtins.readFile ../../config/st.h;
  };
}
