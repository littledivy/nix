{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.vim
    pkgs.git
    pkgs.nixfmt-rfc-style
  ];

  programs.zsh.enable = true;

  nix.settings.experimental-features = "nix-command flakes";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
}
