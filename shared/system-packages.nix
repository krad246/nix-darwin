{ pkgs, ... }: {
  environment = {
    systemPackages = with pkgs; [
      uutils-coreutils

      aria2 # A lightweight parallel command-line download utility
      ripgrep # recursively searches directories for a regex pattern
      safe-rm

      neofetch
      bottom

      neovim
      helix
    ];

    shells = [ pkgs.bashInteractive pkgs.zsh ];
    variables = {
      EDITOR = "${pkgs.neovim}/bin/nvim";
      SUDO_EDITOR = "$EDITOR";
      VISUAL = "$EDITOR";
    };
  };

  programs = {
    bash.enable = true;
    nix-index.enable = true;
    zsh = {
      enable = true;
      enableCompletion = true;
      enableBashCompletion = true;
      enableSyntaxHighlighting = true;
    };
  };
}
