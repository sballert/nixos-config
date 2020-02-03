{ pkgs }:

with pkgs;

{
  gruvbox-rofi = callPackage ./gruvbox-rofi {};
  nix-util = callPackage ./nix-util {};
  session-menu = callPackage ./session-menu {};
  xlogout = callPackage ./xlogout {};
  xrandr-util = callPackage ./xrandr-util {};
}
