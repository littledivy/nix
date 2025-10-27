{ pkgs, lib, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "logi-options-plus";
  version = "latest";

  src = pkgs.fetchurl {
    url = "https://download01.logi.com/web/ftp/pub/techsupport/optionsplus/logioptionsplus_installer.zip";
    sha256 = "sha256-UgusIht0Hf32CT9vdtSAjHc8wvKsmtNU9G+4NHUn4gU=";
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
