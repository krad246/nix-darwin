{...} @ args: let
  inherit (args) hostname;
in {
  networking.hostName = hostname;
  networking.computerName = hostname;
}
