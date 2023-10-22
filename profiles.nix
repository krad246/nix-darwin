rec {
  krad246 = rec {
    username = "krad246";
    commonSpecialArgs = {inherit username;};
    home-manager = {
      inherit username;
      enable = true;
      modules = [./modules/home-manager];
      extraConfig = {home.stateVersion = "23.05";};
    };
  };

  darwinPlatform = { modules = [./shared ./modules/darwin ]; };
}
