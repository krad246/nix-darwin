{ config
, pkgs
, ...
}:
let
  nixpkgsOverrides = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
in
{
  system.stateVersion = 4;
  nixpkgs = { inherit (nixpkgsOverrides) config; };

  # Upgrade to flake package and enable the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nixFlakes;
    checkConfig = true;
    settings = {
      auto-optimise-store = true;
      sandbox = true;
    };

    gc.automatic = true;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # Nice helper interface into the index, like plocate
  programs.nix-index.enable = true;
}
