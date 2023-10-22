{ pkgs, ... }:
let fmt = pkgs.nixpkgs-fmt; in pkgs.symlinkJoin {
  name = "format";
  paths = [ fmt ];
  buildInputs = [ pkgs.makeWrapper ];
}
