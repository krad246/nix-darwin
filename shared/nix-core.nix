{ pkgs, ... } @ rest:
let
  inherit (rest) specialArgs;
in
{
  # system = { inherit (specialArgs) stateVersion; };

  # enable flakes globally
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  programs.nix-index.enable = true;
}
