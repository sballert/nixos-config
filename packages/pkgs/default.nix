{ pkgs }:

with pkgs;

{
  backup = callPackage ./backup {};
  bluetoothctl-menu = callPackage ./bluetoothctl-menu {};
  gruvbox-rofi = callPackage ./gruvbox-rofi {};
  nix-util = callPackage ./nix-util {};
  session-menu = callPackage ./session-menu {};
  toggle-touchpad = callPackage ./toggle-touchpad {};
  xlogout = callPackage ./xlogout {};
  xrandr-util = callPackage ./xrandr-util {};
}
