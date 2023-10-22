{ inputs, ... }: {
  # Basically just a base struct that I'm going to append to.
  darwinPlatform = {
    modules = [ ./modules/nix-darwin ];
    home-manager = {
      enable = true;
      modules = [ ./modules/home-manager/nix-darwin ];
    };
  };

  # We're exporting a functional attribute in order to generate
  # a system. Common interface exposes very little to get started.
  # You need the base 'profile' and then the runtime 'config'.
  createSystem = profile: { system
                          , username
                          , hostname
                          , ...
                          } @ config:
    let
      # Pull in any flake inputs we buried in the variadic
      inherit (inputs) nixpkgs nix-darwin home-manager;

      # Instantiate the base package source, basically
      pkgs = import nixpkgs { inherit system; };
      inherit (pkgs) lib;

      # Handle nonexistent attrs gracefully.
      traceVar = x: x;
      getAttr = v: d: n: lib.attrsets.attrByPath (traceVar n) d (traceVar v);

      # Pull in the module filepaths for each side
      getSysModules = y: getAttr y [ ] [ "modules" ];
      getHmModules = y: getAttr y [ ] [ "home-manager" "modules" ];
      sysModules = [ ./shared ] ++ getSysModules profile ++ getSysModules config;
      hmModules = [ ./shared/home-manager ] ++ getHmModules profile ++ getHmModules config;

      # Forward arguments to the modules
      getSpecialArgs = x: getAttr x { } [ "specialArgs" ];
      getExtraSpecial = x: getAttr x { } [ "extraSpecialArgs" ];

      # Based on home-manager being enabled, add a
      homeEnabled = config.enable or profile.enable or false;
      mkDarwinHome = x: (home-manager.darwinModule x);
    in
    nix-darwin.lib.darwinSystem {
      inherit system;

      modules =
        sysModules
        ++ lib.optionals homeEnabled (mkDarwinHome {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit username; } // inputs // getExtraSpecial profile // getExtraSpecial config;
            sharedModules = hmModules;
            users.${username}.imports = hmModules;
          };
        });

      specialArgs =
        {
          inherit system;
          inherit username hostname;
        }
        // inputs
        // getSpecialArgs profile
        // getSpecialArgs config;
    };
}
