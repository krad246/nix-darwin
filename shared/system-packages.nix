{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    uutils-coreutils

    aria2 # A lightweight parallel command-line download utility
    ripgrep # recursively searches directories for a regex pattern
    safe-rm
    neofetch
    bottom
  ];

  environment.shells = [ pkgs.bashInteractive pkgs.zsh ];
  environment.interactiveShellInit = ''source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh'';
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
