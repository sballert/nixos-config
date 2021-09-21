{ pkgs }: let

  configDir = ./../../config;

in with pkgs.lib; {

  readConfig = configFile: builtins.readFile (configDir + "/${configFile}");

  pathToConfig = configFile: configDir + "/${configFile}";

  compileEmacsFiles = import ./compile-emacs-files.nix;
}
