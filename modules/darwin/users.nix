{
  username,
  pkgs,
  ...
}: {
  users.users.${username} = {
    description = "${username}";
    createHome = true;
    home = "/Users/${username}";
    shell = pkgs.zsh;
    uid = 501; # FIXME
    gid = 20;
  };

  users.knownUsers = ["${username}"];
  nix.settings.trusted-users = ["${username}"];
}
