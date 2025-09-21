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
      pathsToLink = "/Applications";
      paths =
        config.environment.systemPackages
        ++ (lib.concatMap (x: x.home.packages) (lib.attrsets.attrValues config.home-manager.users));
    }
  );

  system.defaults = {
    controlcenter.BatteryShowPercentage = true;
    dock.autohide = true;
    NSGlobalDomain = {
      InitialKeyRepeat = 10;
      KeyRepeat = 1;
      "com.apple.swipescrolldirection" = false;
    };
  };

  users = {
    users."${username}" = {
      home = "/Users/${username}";
      name = "${username}";
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  nixpkgs.hostPlatform = "aarch64-darwin";
}
