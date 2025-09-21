{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget

    # home-manager on darwin does't add it to /Applications
    kitty
    alacritty
  ];

  programs.zsh.enable = true;

  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfree = true;
}
