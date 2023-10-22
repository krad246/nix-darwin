{ pkgs, ... }:
let
  formatter = pkgs.callPackage ./format.nix { };
  linter = pkgs.callPackage ./linter.nix { };
in
{
  inherit formatter;
  default = formatter;
}
