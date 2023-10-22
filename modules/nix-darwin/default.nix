{ lib, ... }: {
  imports = (lib.optionals true [ ./homebrew.nix ]) ++ [ ./managed-users.nix ./system-packages.nix ./system-settings.nix ];
}
