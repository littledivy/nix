{
  pkgs,
  lib,
  config,
  ...
}:
let
  username = "divy";
in
{
  system.primaryUser = username;
  system.build.applications = lib.mkForce (
    pkgs.buildEnv {
      name = "system-applications";
      pathsToLink = [ "/Applications" ];
      paths =
        config.environment.systemPackages
        ++ (lib.concatMap (x: x.home.packages) (lib.attrsets.attrValues config.home-manager.users));
    }
  );

  nix.gc.interval = {
    Weekday = 0;
    Hour = 0;
    Minute = 0;
  };

  system.defaults = {
    controlcenter.BatteryShowPercentage = true;
    WindowManager = {
      GloballyEnabled = false;

      # doesn't exist in nix-darwin
      # AnimationSpeed = 1.0;
      # AutoHideWhenOccluded = true;
    };
    dock = {
      autohide = true;
      # also affects stage manager animation delay
      autohide-delay = 0.0;
    };
    NSGlobalDomain = {
      InitialKeyRepeat = 20;
      KeyRepeat = 1;
      "com.apple.swipescrolldirection" = false;
      AppleInterfaceStyle = "Dark";
    };
  };

  users = {
    users."${username}" = {
      home = "/Users/${username}";
      name = "${username}";
    };
  };

  system.activationScripts.preActivation = {
    enable = true;
    # (note: the DB runs as my user! `staff` is the default non-admin group)
    text =
      let
        dataDir = config.services.postgresql.dataDir;
      in
      ''
        if [ ! -d "${dataDir}" ]; then
          echo "creating PostgreSQL data directory..."
          sudo mkdir -m 750 -p "${dataDir}"
          chown -R ${config.system.primaryUser}:staff "${dataDir}"
        fi
      '';
  };

  services.postgresql.initdbArgs = [
    # We should really change the (internal) `superUser` option instead 🤔
    "-U ${config.system.primaryUser}"
  ];

  launchd.user.agents.postgresql.serviceConfig = {
    StandardErrorPath = "/tmp/postgres.error.log";
    StandardOutPath = "/tmp/postgres.log";
  };
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
            #type database  DBuser  origin-address auth-method
            local all       all     trust
      			host  all       all     all  trust
    '';
  };

  system.activationScripts.extraActivation.text = ''
    softwareupdate --install-rosetta --agree-to-license
  '';

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  nixpkgs.hostPlatform = "aarch64-darwin";
}
