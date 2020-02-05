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

  myNodePackages = import ./node-packages/composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
    nodejs = pkgs.nodejs-12_x;
  };
}
