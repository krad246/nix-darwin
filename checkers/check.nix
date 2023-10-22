{ pkgs, ... } @ rest:
let
  inherit (rest) format lint;
in
pkgs.writeShellApplication {
  name = "check";
  runtimeInputs = [ format lint ];
  text = ''
    ${format}/bin/format && ${lint}/bin/lint
  '';
}
