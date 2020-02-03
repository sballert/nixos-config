{ pkgs ? import <nixpkgs> {} }:

{
  # here could be `lib`, `modules`, or `overlay`
} // (import ./pkgs { inherit pkgs; })
