{
  description = "My NixOS configuration, using home-manager";

  inputs = rec {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # Covers Darwin and Linux
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";

    nixpkgs-system = nixpkgs-stable; # Keep the core as LTS
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-system";
    };

    nixpkgs-user = nixpkgs-unstable; # Userspace is whatever
    mac-app-util.url = "github:hraban/mac-app-util"; # Handles the Spotlight and Dock synchronization
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-user";
    };

    systems.url = "github:nix-systems/default-darwin"; # Platform support
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    home-manager,
    flake-utils,
    ...
  }: let
    inherit (inputs) nixpkgs-system;
    nixpkgs = nix-darwin.inputs.nixpkgs;
    profiles = import ./profiles.nix;
    lib = import ./lib.nix {inherit self inputs nixpkgs;};
  in
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in rec {
      packages = { inherit darwinConfigurations; };
      darwinConfigurations = rec {
        nixos-darwin = lib.createSystem profiles.darwinPlatform {
          hostname = "nixos-darwin";
          username = "krad246";
          inherit system;
        };

        default = nixos-darwin;
      };

      formatter = pkgs.alejandra;
      checks = {format = formatter;};
    });
}
