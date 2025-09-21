{ ... }:
let
  username = "divy";
in
{
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
