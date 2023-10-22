{ config
, pkgs
, ...
}: {
  home.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
    SUDO_EDITOR = "$EDITOR";
    VISUAL = "$EDITOR";
  };

  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [ ];

    plugins = with pkgs.vimPlugins; [
      vim-multiple-cursors
      vim-surround
      editorconfig-nvim
      vim-gitgutter
      vim-airline
      nvim-web-devicons

      # Better syntax highlighting and indentation
      nvim-treesitter.withAllGrammars

      {
        # Automatically changes pwd to git trees root
        plugin = vim-rooter;
        config = ''
          let g:rooter_patterns = ['.git', '=${config.home.homeDirectory}/nix/nixpkgs' ]
        '';
      }
      {
        # Tree-like file manager
        plugin = nvim-tree-lua;
      }
    ];

    extraConfig = ''
      syntax enable
      set number
      set mouse=a
      set updatetime=300
      set signcolumn=number
      set noshowmode

      " various fixes for the tab key
      set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
      autocmd FileType nix set tabstop=2 softtabstop=0 shiftwidth=2 expandtab
    '';
  };
}
