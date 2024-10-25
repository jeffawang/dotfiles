{
  description = "";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {self, nixpkgs, home-manager}: let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [];
        };
      };
      home = import ./home.nix {
        inherit pkgs;
      };
    in {
      homeConfigurations = {
        "jeffwang" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ home ];
        };
      };
  };
}
