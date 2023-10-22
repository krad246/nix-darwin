{
  darwinPlatform = {
    modules = [ ./shared ./modules/darwin ];
    home-manager = {
      enable = false;
      modules = [ ./modules/home-manager ];
    };
  };
}
