{ pkgs, ... }:

let
  username = "jeffwang";
  dotfiles = "$HOME/code/dotfiles";
in {
  home = {
    inherit username;
    stateVersion = "24.05";
    homeDirectory = "/Users/${username}";

    # Attribute set for {ENV_VAR = ENV_VALUE}
    #   sets it for all shells
    # sessionVariables = {};

    # Put packages here if they don't have configuration
    packages = [
    ];
    file.stuff = {text = "things";};
  };

  # Configure program-specific stuff here
  programs = {
    bash = {
      enable = true;
    };
  };
}
