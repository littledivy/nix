{ pkgs, lib, ... }:
let
in
{
  /*
    This is broken. managing npm with nix is just not worth it.

    launchd.user.agents.n8n = {
      command = "$HOME/.npm-packages/bin/n8n start --tunnel";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
      EnvironmentVariables = {
        PATH = "$HOME/.npm-packages/bin:${pkgs.nodejs}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
        StandardOutPath = "/Users/divy/Library/Logs/n8n.log";
        StandardErrorPath = "/Users/divy/Library/Logs/n8n.err";
      };
    };
  */

  environment.systemPackages = [
    pkgs.nodejs
    pkgs.cloudflared
  ];
}
