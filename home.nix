{ pkgs, ... }:

let
  username = "jeffwang";
in {
  home = {
    inherit username;
    stateVersion = "24.05";
    homeDirectory = "/Users/${username}";
    packages = [

    ];
    file.stuff = {text = "things";};
  };
}
