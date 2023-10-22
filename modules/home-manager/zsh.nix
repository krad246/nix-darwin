{ pkgs, ... }: {
  programs.zsh = {
    enable = true;

    enableAutosuggestions = true;
    enableCompletion = true;
    enableVteIntegration = true;
    autocd = true;

    history.path = "$HOME/.cache/zsh/history";
    history.expireDuplicatesFirst = true;
    history.extended = true;
    historySubstringSearch.enable = true;

    oh-my-zsh = {
      enable = false;
      plugins = [ ];
      theme = "gruvbox";
    };

    plugins = [ ];

    shellAliases = {
      ls = "ls --color=auto";
      cat = "${pkgs.bat}/bin/bat -p";
    };

    syntaxHighlighting = {
      enable = true;
    };

    initExtra = ''
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    '';
  };
}
