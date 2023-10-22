{ ... } @ extraSpecialArgs: {
  imports =
    [ ./shims ]
    ++ [ ./bat.nix ./dircolors.nix ./direnv.nix ./gh.nix ./git.nix ./kitty.nix ./nix-index.nix ./nvim.nix ./starship.nix ./zsh.nix ]
    ++ [ ./apps.nix ];

  # Applies inside of the home-manager config
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
    experimental-features = "nix-command flakes";
  };

  # Applies for imperative commands
  xdg.configFile."nixpkgs/config.nix".text = ''
    {
      allowUnfree = true;
      experimental-features = "nix-command flakes";
    }
  '';

  home.stateVersion = "23.05";
  # home = builtins.trace extraSpecialArgs {};
}
