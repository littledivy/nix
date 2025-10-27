{
  config,
  lib,
  pkgs,
  ...
}:

let
  buildonPkg = pkgs.buildGoModule rec {
    pname = "buildon";
    version = "0.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "littledivy";
      repo = "buildon";
      rev = "472b999";
      sha256 = "sha256-J95sHFJrLw435KAFDfdsEXQ2wCkVxLwd1a7syeM9OGk=";
    };

    vendorHash = "sha256-GkyRdDnokFlWIG5UMIUhA/QDpVgLPrGm6TS9CNXlHJI=";

    meta = with lib; {
      description = "Quick sync, ssh and build on remote machines";
      license = licenses.mit;
      maintainers = [ maintainers.littledivy ];
    };
  };

  toml = pkgs.formats.toml { };
in
{
  options.programs.buildon = {
    enable = lib.mkEnableOption "buildon remote builder tool";

    package = lib.mkOption {
      type = lib.types.package;
      default = buildonPkg;
      description = "Which buildon package to use.";
    };

    remotes = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
      default = { };
      description = "Remote machine definitions (→ [remote.<name>] tables).";
    };
  };

  config = lib.mkIf config.programs.buildon.enable {
    home.packages = [ config.programs.buildon.package ];

    home.file.".config/buildon/config.toml".source = toml.generate "config.toml" {
      remote = config.programs.buildon.remotes;
    };
  };
}
