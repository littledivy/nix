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
  prr = pkgs.prr.overrideAttrs {
    src = pkgs.fetchFromGitHub {
      owner = "danobi";
      repo = "prr";
      rev = "e5076af";
      sha256 = "sha256-jCW/oKrPDTc8Mn7FV7xUMM8m+3bRSBv4iyU4HiOr0Qg=";
    };
    cargoHash = lib.fakeSha256;
  };

  toml = pkgs.formats.toml { };
  logi-options-plus = import ./pkgs/logi-options-plus.nix { inherit pkgs lib; };
  plex = import ./pkgs/plex.nix { inherit pkgs lib; };
in
{
  programs.home-manager.enable = true;

  home.stateVersion = "25.05";

  imports = [ ./pkgs/buildon.nix ];
  home.packages =
    (
      with pkgs;
      [
        kitty
        discord
        rustup
        go
        llvmPackages_20.clang
        lld_20
        llvmPackages_20.libcxx
        nixfmt-rfc-style
        deno
        gh
        nodejs_24
        google-chrome
        ripgrep
        lazygit
        yubikey-manager # ykman otp swap (prevent accidental triggers)
      ]
      ++ lib.optionals stdenv.isLinux [
        deskflow # todo: add a macOS pkg
        rofi
      ]
      ++ lib.optionals stdenv.isDarwin [
        # can't really escape unfree on macOS

        raycast
        shortcat
        whatsapp-for-mac # update to 25.27.11
      ]
    )
    ++ lib.optionals pkgs.stdenv.isDarwin [
      logi-options-plus
      plex
    ]
    ++ [
      prr
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

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.npm-packages/bin"
  ];

  home.sessionVariables = {
    NODE_PATH = "$HOME/.npm-packages/lib/node_modules";
  };

  home.file.".npmrc".text = "prefix = \${HOME}/.npm-packages";

  programs.git = {
    enable = true;
    userName = "Divy Srivastava";
    userEmail = "me@littledivy.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.firefox.enable = false;

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

  home.file.".config/prr/config.toml".source = toml.generate "config.toml" {
    prr = {
      workdir = "${config.home.homeDirectory}/prr";
      token = "";
    };
  };

  home.activation.vimrcLocalOverride = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    local_path="$HOME/vimrc/.vimrc"
    if [ -f "$local_path" ]; then
      echo "Overriding .vimrc with local checkout: $local_path"
      rm -f "$HOME/.vimrc"
      ln -s "$local_path" "$HOME/.vimrc"
    fi
  '';
}
