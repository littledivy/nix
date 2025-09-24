{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.deskflow-client;
in {
  options.services.deskflow-client = {
    enable = mkEnableOption "Deskflow client service";

    serverAddress = mkOption {
      type = types.str;
      default = "192.168.110.160:24800";
      description = "The address of the Deskflow server to connect to";
    };

    clientName = mkOption {
      type = types.str;
      default = config.networking.hostName;
      description = "The name of this client";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.deskflow;
      description = "The Deskflow package to use";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Extra arguments to pass to deskflow-client";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.deskflow-client = {
      description = "Deskflow client";
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"];

      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/deskflow-client -f \
            --debug INFO \
            --name ${cfg.clientName} \
            --enable-crypto \
            --sync-language \
            ${concatStringsSep " " cfg.extraArgs} \
            ${cfg.serverAddress}
        '';
        Restart = "always";
        RestartSec = 3;
      };
    };
  };
}
