# https://github.com/nix-community/home-manager/issues/1341#issuecomment-1716147796
{
  config,
  pkgs,
  lib,
  mac-app-util,
  ...
} @ args: let
  inherit (args) username;
  inherit (pkgs) stdenv;

  manager = mac-app-util.packages.${pkgs.stdenv.system}.default;
in {
  home.activation = {
    trampolineApps = lib.hm.dag.entryAfter ["writeBoundary"] ''
      fromDir="$HOME/Applications/Home Manager Apps"
      toDir="$HOME/Applications/Home Manager Trampolines"
      ${manager}/bin/mac-app-util sync-trampolines "$fromDir" "$toDir"
    '';
  };
}
