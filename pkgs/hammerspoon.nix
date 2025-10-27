{ pkgs, lib, ... }:

let
  pname = "hammerspoon";
  version = "0.9.97";
  appName = "Hammerspoon.app";
in
pkgs.stdenv.mkDerivation {
  inherit pname version;

  src = pkgs.fetchzip {
    url = "https://github.com/Hammerspoon/hammerspoon/releases/download/${version}/Hammerspoon-${version}.zip";
    sha256 = "13cGdXjWeig0hUTdiCmiQdq3wcnbPOjnRRAA7hMn690=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/${appName}
    cp -R . $out/Applications/${appName}

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.hammerspoon.org";
    description = "A tool for powerful automation of macOS";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
