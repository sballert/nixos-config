{ pkgs ? import <nixpkgs> {} }:

with pkgs;

{

  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  overlays = import ./overlays;

  backup = callPackage ./pkgs/backup {};
  bluetoothctl-menu = callPackage ./pkgs/bluetoothctl-menu {};
  gruvbox-rofi = callPackage ./pkgs/gruvbox-rofi {};
  nix-util = callPackage ./pkgs/nix-util {};
  onlykey-udev = callPackage ./pkgs/onlykey-udev {};
  session-menu = callPackage ./pkgs/session-menu {};
  toggle-screen-locker = callPackage ./pkgs/toggle-screen-locker {};
  toggle-touchpad = callPackage ./pkgs/toggle-touchpad {};
  xlogout = callPackage ./pkgs/xlogout {};
  xrandr-util = callPackage ./pkgs/xrandr-util {};

  nodePackages = import ./pkgs/node-packages/composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
    nodejs = pkgs.nodejs;
  };
}
