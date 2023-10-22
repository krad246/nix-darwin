{
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    global.brewfile = true;

    taps = [
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
    ];

    # If an app isn't available in the Mac App Store, or the version in the App Store has
    # limitiations, e.g., Transmit, install the Homebrew Cask.
    casks = [ "arc" "signal" ];
  };
}
