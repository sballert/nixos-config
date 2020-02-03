{ pkgs ? import <nixpkgs> {} }: {
  gruvbox-rofi = pkgs.callPackage ./pkgs/gruvbox-rofi {};
  xrandr-util = pkgs.callPackage ./pkgs/xrandr-util {};
}
