{ pkgs, lib, ... }:

{
  config = lib.mkMerge [
    {
      environment.systemPackages = with pkgs; [
        vim
        git
        curl
        wget
      ];

      programs.zsh.enable = true;

      nix.gc = {
        automatic = true;
        options = "--delete-older-than 2d";
      };

      nix.settings.experimental-features = "nix-command flakes";
      nixpkgs.config.allowUnfree = true;
    }
  ];
}
