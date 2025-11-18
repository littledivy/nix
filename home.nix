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
				kitty # blocked on https://github.com/NixOS/nixpkgs/issues/461406
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
        go-font
        claude-code
        yubikey-manager # ykman otp swap (prevent accidental triggers)
      ]
      ++ lib.optionals stdenv.isLinux [
        rofi
      ]
      ++ lib.optionals stdenv.isDarwin [
        # can't really escape unfree on macOS

        raycast
        shortcat
				# broken: https://github.com/NixOS/nixpkgs/pull/445181
        # whatsapp-for-mac # update to 25.27.11
      ]
    )
    ++ lib.optionals pkgs.stdenv.isDarwin [
      logi-options-plus
      plex
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
		settings = {
      init.defaultBranch = "main";
			user = {
  			name = "Divy Srivastava";
				email = "me@littledivy.com";
			};
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
      enable_audio_bell = false;

      font_family = "Go Mono";
    };
  };

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
