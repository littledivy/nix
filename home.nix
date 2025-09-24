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
    rev = "5bc8a5d";
    sha256 = "sha256-OIMKlO1mtY0Y5x0RudsXYr2CLJSaBOoi/lTbtnyO4sk=";
  };

  apple-music-rpc =
    if pkgs.stdenv.isDarwin then
      pkgs.fetchFromGitHub {
        owner = "NextFire";
        repo = "apple-music-discord-rpc";
        rev = "aa56ed5";
        sha256 = "sha256-NCUXuHxQI3hHpnuEVn7+QHNVXK7C7RPa/x7WCNz3Ut8=";
      }
    else
      null;

  logi-options-plus = import ./pkgs/logi-options-plus.nix { inherit pkgs lib; };
in
{
  imports = [ ./pkgs/buildon.nix ];
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
        go
        llvmPackages_20.clang
        lld_20
        llvmPackages_20.libcxx
        nixfmt-rfc-style
        typst
        typstyle
        prr
        deno
        gh
        nodejs_24
        google-chrome
        ripgrep
        lazygit
        lan-mouse
        yubikey-manager # ykman otp swap (prevent accidental triggers)
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
      ]
    )
    ++ lib.optionals pkgs.stdenv.isDarwin [
      logi-options-plus
    ];

  programs.buildon = {
    enable = true;
    remotes.mac-mini = {
      host = "divys-Mac-mini.local";
      user = "divy";
      path = "deno/";
    };
  };

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

  launchd.agents.apple-music-rpc =
    if pkgs.stdenv.isDarwin then
      {
        enable = true;
        config = {
          Label = "moe.yuru.music-rpc";
          ProgramArguments = [
            "sh"
            "-c"
            "cd '${config.home.homeDirectory}/Library/Caches/' && exec ${pkgs.deno}/bin/deno run --unstable-kv --allow-write --allow-import --allow-env --allow-net --allow-run --allow-read ${apple-music-rpc}/music-rpc.ts"
          ];
          WorkingDirectory = "${apple-music-rpc}";
          EnvironmentVariables = {
            PATH = "${pkgs.deno}/bin:/usr/bin";
          };
          RunAtLoad = true;
          KeepAlive = true;

          StandardOutPath = "${config.home.homeDirectory}/Library/Logs/apple-music-rpc.out.log";
          StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/apple-music-rpc.err.log";
        };
      }
    else
      null;

  home.file.".vimrc".source = "${vimrc}/.vimrc";
  home.file.".vimrc".force = true;

  home.activation.vimrcLocalOverride = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    local_path="$HOME/vimrc/.vimrc"
    if [ -f "$local_path" ]; then
      echo "Overriding .vimrc with local checkout: $local_path"
      rm -f "$HOME/.vimrc"
      ln -s "$local_path" "$HOME/.vimrc"
    fi
  '';
}
