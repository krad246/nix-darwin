# https://github.com/nix-community/home-manager/issues/1341#issuecomment-1716147796
{ lib, ... } @ inputs:
let
  inherit (inputs) dockutil;
in
{
  home.activation = {
    trampolineApps = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      fromDir="$HOME/Applications/Home Manager Apps"
      toDir="$HOME/Applications/Home Manager Trampolines"
      ${dockutil}/bin/mac-app-util sync-trampolines "$fromDir" "$toDir"
    '';
  };
}
