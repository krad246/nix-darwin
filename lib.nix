{...} @ rest: let
  inherit (rest) inputs nixpkgs;
  inherit (nixpkgs) lib;
in {
  createSystem = profile: {
    system,
    modules ? [],
    extraConfig ? {},
    home-manager ? {},
    specialArgs ? {},
    commonSpecialArgs ? {},
    ...
  } @ args: let
    profileModules = profile.modules or [];
    profileSystemArgs = profile.specialArgs or {};
    profileSharedArgs = profile.commonSpecialArgs or {};

    profileHomeModules = profile.home-manager.modules or [];
    runtimeHomeModules = home-manager.modules or [];
    profileHomeArgs = profile.home-manager.specialArgs or {};
    runtimeHomeArgs = home-manager.specialArgs or {};

    # Combine the runtime function args with some profile args
    # TODO: Determine the full reason for this design
    # sourced from https://github.com/IvarWithoutBones/dotfiles.git
    systemModuleArgs = lib.mergeAttrs specialArgs profileSystemArgs;
    homeModuleArgs = lib.mergeAttrs runtimeHomeArgs profileHomeArgs;
    sharedModuleArgs = lib.mergeAttrs commonSpecialArgs profileSharedArgs;

    homeEnabled = (profile.home-manager.enable or false) || (home-manager.enable or false);
    homeModules = profileHomeModules ++ runtimeHomeModules;
    sharedModules = modules ++ profileModules;

    configUsername =
      lib.optionalString homeEnabled
      (home-manager.username or profile.home-manager.username);
    configHostname =
      lib.optionalString homeEnabled
      (home-manager.hostname or profile.home-manager.hostname);
  in
    inputs.nix-darwin.lib.darwinSystem rec {
      inherit system;

      specialArgs =
        {
          inherit system;
        }
        // inputs
        // sharedModuleArgs
        // systemModuleArgs
        // {
          username = configUsername;
          hostname = configHostname;
        };

      modules =
        sharedModules
        ++ lib.optionals homeEnabled [
          inputs.home-manager.darwinModule
          {
            home-manager = rec {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs =
                {
                  inherit system;
                }
                // inputs
                // homeModuleArgs
                // sharedModuleArgs;

              sharedModules = homeModules;
              users.${configUsername} = {
                imports = homeModules;
              };
            };
          }
        ];
    };
}
