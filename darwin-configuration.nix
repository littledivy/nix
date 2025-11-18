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
      pathsToLink = ["/Applications"];
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

 system.activationScripts.extraActivation.text = ''
    softwareupdate --install-rosetta --agree-to-license
  '';

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  nixpkgs.hostPlatform = "aarch64-darwin";
}
