{ pkgs, pname, src, command, ... }:
let
  inherit pname;
  bin = pkgs."${pname}";
in
with pkgs; runCommand
{
  name = "${pname}";
  buildInputs = [ bin ];
  inherit src;
} '' ${command} ''
