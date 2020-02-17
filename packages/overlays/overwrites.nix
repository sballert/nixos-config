self: super:

{
  slock = super.slock.override {
    conf = builtins.readFile ./slock.h;
  };
  st = super.st.override {
    conf = builtins.readFile ./st.h;
  };

  /*
  perl = super.buildEnv {
    inherit (super.perl) name;
    paths = [super.perl] ++ [
      super.perlPackages.DBI
      super.perlPackages.DBDPg
      super.perlPackages.RPCEPCService
    ];

    # self.perlPackageList perlPackages;
  };
  */


  /*
  perl = super.perl.withPackages (p: [
    p.DBI
    p.DBDPg
    p.RPCEPCService
  ]);
  */
}
