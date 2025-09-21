{
  config,
  pkgs,
  lib,
  ...
}:
let
  vimrc = pkgs.fetchFromGitHub {
    owner = "littledivy";
    repo = "vimrc";
    rev = "main";
    sha256 = "sha256-EKM8BTnYm/FSiYd1AMThwg6m/TZEcbeOIFhxEio6IFU=";
  };
in
{
  programs.home-manager.enable = true;

  home.stateVersion = "25.05";

  home.packages =
    with pkgs;
    [
      kitty
      alacritty
      slack
      discord
      rustup
      nixfmt-rfc-style
      typst
      typstyle
      prr
      deno
      nodejs_24
      google-chrome
    ]
    ++ lib.optionals stdenv.isLinux [
      rofi
    ]
    ++ lib.optionals stdenv.isDarwin [
      # can't really escape unfree on macOS

      skimpdf
      raycast
      shortcat
      whatsapp-for-mac # update to 25.27.11
      # apple-music-rpc
      # hammerspoon
    ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ll = "ls -l";
      k = "kubectl";
    };
  };

  programs.firefox.enable = true;
  home.file.".vimrc".source = "${vimrc}/.vimrc";
}
