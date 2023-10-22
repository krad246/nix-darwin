{
  description = "My NixOS configuration, using home-manager";

  inputs = rec {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # Covers Darwin + Linux
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";

    nixpkgs-system = nixpkgs-unstable;
    nixpkgs = nixpkgs-system;

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-user = nixpkgs;
    mac-app-util.url = "github:hraban/mac-app-util"; # Handles the Spotlight and Dock synchronization
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/default-darwin"; # Platform support
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  };

  outputs = inputs @ { nixpkgs, ... }:
    let
      inherit (inputs) mac-app-util flake-utils;
    in
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          # Load the package source distribution
          pkgs = import nixpkgs { inherit system; };
          inherit (pkgs) lib;

          # Load the glue logic composing the system
          factory = pkgs.callPackage ./factory.nix {
            inherit system inputs;
          };

          # Load in the testing infra here
          checkers = pkgs.callPackage ./checkers { inherit pkgs; };
          dockutil = pkgs.callPackage (with system; mac-app-util { inherit pkgs; });

          # For a whopping 1 machine, for now...
          hostname = "nixos-darwin";
          username = "krad246";
          machine = factory.createSystem factory.darwinPlatform {

            inherit system username hostname;

            specialArgs = {
              system.stateVersion = 4;
              inherit dockutil;
            };

            extraSpecialArgs = {
              home.stateVersion = "23.05";
              inherit dockutil;
            };
          };

          darwinConfigurations = {
            "${hostname}" = machine;
            default = machine;
          };
        in
        {
          # Basically, the legacy and darwin interfaces expect a function
          # while packages expects a fully evaluated derivation.
          inherit darwinConfigurations;
          legacyPackages = { inherit darwinConfigurations; };
          packages = rec {
            inherit (machine) system;
            default = system;
          };

          inherit (checkers) formatter;
          checks = {
            inherit (checkers) default;
          };

          devShells = {
            default = pkgs.mkShell {
              packages = (with pkgs; [ just direnv nix-direnv ]) ++ (with checkers; [ formatter ]);
            };
          };
        });
}
