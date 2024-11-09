.PHONY: switch
switch:
	nix run github:nix-community/home-manager -- switch --show-trace --flake  .
