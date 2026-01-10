{ pkgs, lib, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "logi-options-plus";
  version = "latest";

  src = pkgs.fetchurl {
    url = "https://download01.logi.com/web/ftp/pub/techsupport/optionsplus/logioptionsplus_installer.zip";
    sha256 = "sha256-tQApdPpk6NNWWNUAAnvCTSXmQa6I0b7RwvIUmwjeNX8=";
  };

  # skip default unpack
  unpackPhase = ''
    true
  '';

  nativeBuildInputs = [ pkgs.unzip ];

  buildPhase = ''
    mkdir -p $out
    unzip $src -d $out
  '';

  installPhase = ''
        cat > $out/logi-options-plus <<EOF
    #!/usr/bin/env bash
    open "$out/logioptionsplus_installer.app"
    EOF
        chmod +x $out/logi-options-plus
  '';

  meta = with pkgs.lib; {
    description = "Logitech Options Plus wrapper for macOS";
    license = pkgs.lib.licenses.unfree;
  };
}
