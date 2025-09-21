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
      nixfmt-rfc-style
    ]
    ++ lib.optionals stdenv.isLinux [
      rofi
    ];

  home.file.".vimrc".source = "${vimrc}/.vimrc";
}
