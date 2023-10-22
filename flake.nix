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
    home-manager.url = "github:nix-community/home-manager";
    systems.url = "github:nix-systems/default-darwin"; # Platform support
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs =
    inputs @ { self
    , nix-darwin
    , home-manager
    , flake-utils
    , ...
    }:

    let
      inherit (inputs) nixpkgs-stable;
      inherit (self) outputs;
      profiles = import ./profiles.nix;
      lib = import ./lib.nix { inherit self inputs; nixpkgs = nixpkgs-stable; };
    in

    flake-utils.lib.eachDefaultSystem
      (system:
      let
        tool-pkgs = import nixpkgs-stable { inherit system; };
        
        inherit (inputs) nixpkgs-system nixpkgs-user;
        system-pkgs = import nixpkgs-system { inherit system; };
        user-pkgs = import nixpkgs-user { inherit system; };
      in
      rec {
        formatter = tool-pkgs.nixpkgs-fmt;
        checks = { format = formatter; };

        darwinConfigurations = 
          rec {
            nixos-darwin = lib.createSystem profiles.darwinPlatform {
              hostname = "nixos-darwin";
            username = "krad246";
            inherit system;

            specialArgs = { system.stateVersion = 4; }; # nix-darwin has different numbers
            extraSpecialArgs = { home.stateVersion = "23.05"; };
          };

          default = nixos-darwin;
        };
        packages = rec { inherit (darwinConfigurations.default) system; default = system; };
        legacyPackages = { inherit darwinConfigurations; };
    });
}
