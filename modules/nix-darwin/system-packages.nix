{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ m-cli ];
}
