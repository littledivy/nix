{
  description = "Divy's nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      nixos-wsl,
      home-manager,
    }:
    let
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        iso = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./iso.nix
          ];
        };

        msi-laptop = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./common.nix
            ./configuration.nix
            ./hardware-configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.divy = ./home.nix;
            }
          ];
        };

        wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./common.nix
            nixos-wsl.nixosModules.default
            {
              wsl.enable = true;
            }
          ];
        };
      };

      darwinConfigurations = {
        m1-macbook = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./common.nix
            ./darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.sharedModules = [
                (
                  { config, pkgs, ... }:
                  {

                    targets.darwin.linkApps.enable = false;
                  }
                )
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.divy = ./home.nix;
              home-manager.backupFileExtension = "bak";
            }
          ];
        };

        m1-mac-mini = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./common.nix
            ./darwin-configuration.nix
            ./lab2.nix
            {
              networking.wakeOnLan.enable = true;
            }
            home-manager.darwinModules.home-manager
            {
              home-manager.sharedModules = [
                (
                  { config, pkgs, ... }:
                  {

                    targets.darwin.linkApps.enable = false;
                  }
                )
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.divy = ./home.nix;
            }
          ];
        };
      };
    };
}
