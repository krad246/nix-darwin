{ config
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    discord
    spotify
    vscode
    zoom-us
    obsidian
  ];
}
