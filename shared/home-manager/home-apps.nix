{ pkgs, ... }: {
  home.packages = with pkgs; [
    discord
    spotify
    vscode
    zoom-us
    obsidian
    bitwarden
  ];

  imports = [ ./tools.nix ];
}
