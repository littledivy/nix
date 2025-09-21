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
    sha256 = "sha256-XJ0pJpjqeKYAFQrAE8xdflFkf9Iw5SN8xLQouMAe4WI=";
  };
  logiOptionsPlus = import ./pkgs/logi-options-plus.nix { inherit pkgs lib; };
in
{
  programs.home-manager.enable = true;

  home.stateVersion = "25.05";

  home.packages =
    (
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
        ripgrep
        lazygit
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
      ]
    )
    ++ lib.optionals pkgs.stdenv.isDarwin [
      logiOptionsPlus
    ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ll = "ls -l";
      k = "kubectl";
    };
  };

  programs.git = {
    enable = true;
    userName = "Divy Srivastava";
    userEmail = "me@littledivy.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.firefox.enable = true;

  programs.kitty = {
    enable = true;
    settings = {
      cursor_shape = "block";
      # https://github.com/vim/colorschemes/blob/master/colors/habamax.vim
      background = "#1c1c1c";
      foreground = "#bcbcbc";
    };
  };

  home.file.".vimrc".source = "${vimrc}/.vimrc";
}
