{
  config,
  lib,
  pkgs,
  ...
}:
let
  dwmSrc = pkgs.fetchFromGitHub {
    owner = "littledivy";
    repo = "dwm";
    rev = "8cc96dc";
    sha256 = "sha256-ZqJavQpl1m/bDf2PyOhvjPbasNmxk6MfkBK3v5V7Gjo=";
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ./pkgs/deskflow-client.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "divy-nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;
  services.xserver.windowManager.dwm.enable = true;
  services.xserver.windowManager.dwm.package = pkgs.dwm.overrideAttrs {
    src = dwmSrc;
  };
  services.displayManager.autoLogin.user = "divy";
  services.displayManager.autoLogin.enable = true;

  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  users.users.divy = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager"
    ];
    packages = with pkgs; [
      tree
    ];
  };

  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      UseDns = true;
      X11Forwarding = true;
    };
  };

  # Delete /etc/systemd/user/deskflow-client.service to take effect before nixos-rebuild switch
  services.deskflow-client = {
    enable = true;
    serverAddress = "divys-MacBook-Pro.local";
    # serverAddress = "192.168.1.26";
    clientName = "divy-nixos";
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05";
}
