{ pkgs, ... }:
pkgs.symlinkJoin {
  name = "lint";
  paths = with pkgs; [ statix deadnix ];
  buildInputs = [ pkgs.makeWrapper ];
}
