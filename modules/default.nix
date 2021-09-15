{ config, lib, pkgs, ... }:

{
  imports = [
    ./v4l2loopback.nix
  ];
}
