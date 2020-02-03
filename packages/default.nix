{ pkgs ? import <nixpkgs> {} }: {
  gruvbox-rofi = pkgs.callPackage ./pkgs/gruvbox-rofi {};
}
