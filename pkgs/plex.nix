{ pkgs, lib, ... }:

# defaults write com.plexapp.plexmediaserver enableLocalSecurity -bool false
pkgs.stdenv.mkDerivation rec {
  pname = "Plex Media Server";
  appName = "Plex Media Server.app";
  version = "1.42.2.10156-f737b826c";

  # https://downloads.plex.tv/plex-media-server-new/1.42.2.10156-f737b826c/macos/PlexMediaServer-1.42.2.10156-f737b826c-universal.zip
  src = pkgs.fetchurl {
    name = "PlexMediaServer-${version}.zip";
    url = "https://downloads.plex.tv/plex-media-server-new/${version}/macos/PlexMediaServer-${version}-universal.zip";
    sha256 = "sha256-+8BSZhLCrMFCbGV3AISP2+uNZ5bEUVVIcDGZ3/EKuAE=";
  };

  buildInputs = [ pkgs.undmg pkgs.unzip ];

  dontStrip = true;
  #sourceRoot = ".";
  #outputs = ["out"];

  installPhase = ''
    mkdir -p "$out/Applications/${appName}"
    cp -pR * $out/Applications/"${appName}"
  '';

  meta = with pkgs.lib; {
    description = "Plex Media Server";
    homepage = "https://www.plex.tv/media-server-downloads/#plex-media-server";
  };
}
