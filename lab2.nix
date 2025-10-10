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

  system.defaults = {
    dock = {
      mineffect = "scale";
      launchanim = true;
    };

    universalaccess = {
      reduceMotion = true;
      reduceTransparency = true;
    };
    NSGlobalDomain = {
      "com.apple.sound.beep.volume" = 0.0;
    };

    loginwindow = {
      GuestEnabled = false;
      autoLoginUser = "divy";
    };
  };

  system.activationScripts.extraActivation.text = ''
    # Energy settings for server usage
    echo "Configuring power management settings for Mac mini server..."

    # Prevent automatic sleeping, enable wake for network access, auto restart after power failure
    /usr/bin/pmset -a sleep 0
    /usr/bin/pmset -a displaysleep 5
    /usr/bin/pmset -a womp 1
    /usr/bin/pmset -a autorestart 1

    # Disable Wi-Fi and Bluetooth for power savings (uncomment if desired)
    # /usr/sbin/networksetup -setairportpower en0 off
    # /usr/bin/blueutil -p 0

    echo "Power management settings configured."
  '';

  environment.systemPackages = [
    pkgs.nodejs
    pkgs.cloudflared
  ];
}
