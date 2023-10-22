{ ... } @ rest:
let
  inherit (rest) inputs nixpkgs;
  inherit (nixpkgs) lib;
in
{
  createSystem = profile: { system
                          , modules ? [ ]
                          , extraConfig ? { }
                          , home-manager ? { }
                          , specialArgs ? { }
                          , extraSpecialArgs ? { }
                          , commonSpecialArgs ? { }
                          , ...
                          } @ args:
    let
      inherit (args) username hostname;

      profileModules = profile.modules or [ ];
      profileSystemArgs = profile.specialArgs or { };
      profileSharedArgs = profile.commonSpecialArgs or { };

      profileHomeModules = profile.home-manager.modules or [ ];
      runtimeHomeModules = home-manager.modules or [ ];
      profileHomeArgs = profile.home-manager.extraSpecialArgs or { };
      runtimeHomeArgs = home-manager.extraSpecialArgs or { };

      # Combine the runtime function args with some profile args
      # TODO: Determine the full reason for this design
      # sourced from https://github.com/IvarWithoutBones/dotfiles.git
      systemModuleArgs = lib.mergeAttrs specialArgs profileSystemArgs;
      homeModuleArgs = lib.mergeAttrs runtimeHomeArgs profileHomeArgs;
      sharedModuleArgs = lib.mergeAttrs commonSpecialArgs profileSharedArgs;

      homeEnabled = (profile.home-manager.enable or false) || (home-manager.enable or false);
      homeModules = profileHomeModules ++ runtimeHomeModules;
      sharedModules = modules ++ profileModules;
      systemModules = sharedModules;
    in
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;

      specialArgs =
        {
          inherit system;
          inherit username hostname;
        }
        // inputs
        // sharedModuleArgs
        // systemModuleArgs;

      modules =
        systemModules
        ++ (lib.optionals homeEnabled [
          inputs.home-manager.darwinModule
          {
            inherit lib;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit system username; } // inputs // homeModuleArgs // sharedModuleArgs;
              sharedModules = homeModules;
              users.${username} = {
                imports = homeModules;
                home.stateVersion = "23.05";
              };
            };
          }
        ]);
    };
}
