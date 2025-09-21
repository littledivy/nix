{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
  ];

  programs.zsh.enable = true;

  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfree = true;
}
