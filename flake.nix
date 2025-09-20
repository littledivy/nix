{
  description = "Divy's nix";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      msiLaptop = lib.nixosSystem {
        system = "x86_64-linux";
	modules = [
	  ./configuration.nix
          ./hardware-configuration.nix
	];
      };
    };
  };
}
