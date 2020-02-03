{ pkgs }:

with pkgs;

{
  gruvbox-rofi = callPackage ./gruvbox-rofi {};
  nix-util = callPackage ./nix-util {};
  xrandr-util = callPackage ./xrandr-util {};
}
