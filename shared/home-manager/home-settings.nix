{
  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
    keep-outputs = true
    keep-derivations = true
  '';
}
