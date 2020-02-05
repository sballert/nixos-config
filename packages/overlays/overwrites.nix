self: super:

{
  slock = super.slock.override {
    conf = builtins.readFile ./slock.h;
  };
  st = super.st.override {
    conf = builtins.readFile ./st.h;
  };
}
