{
  imports = [
    ./users.nix
    ./system-settings.nix
    ./homebrew.nix
  ];

  nixpkgs.config.allowUnfree = true;
}
