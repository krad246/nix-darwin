{
  programs = {
    bat = {
      enable = true;
      config.theme = "gruvbox-dark";
    };

    direnv = {
      enable = true;
      silent = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      aliases = { };
      extraConfig = { pull.rebase = true; };

      # Prettier pager, adds syntax highlighting and line numbers
      delta = {
        enable = true;
        options = {
          navigate = true;
          line-numbers = true;
          conflictstyle = "diff3";
        };
      };
    };

    gh = { enable = true; };

    kitty = {
      enable = true;
      shellIntegration.mode = "enabled";
      theme = "Gruvbox Material Dark Soft";
      font = {
        name = "meslo-lg";
        size = 12.0;
      };
      extraConfig = ''
        confirm_os_window_close = 0
      '';
    };

    nix-index = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    zoxide.enable = true;
  };

  imports = [ ./nvim.nix ./zsh.nix ];
}
