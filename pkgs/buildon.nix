{ pkgs, lib, ... }:

pkgs.buildGoModule rec {
  pname = "buildon";
  version = "0.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "littledivy";
    repo = "buildon";
    rev = "472b999";
    sha256 = "sha256-J95sHFJrLw435KAFDfdsEXQ2wCkVxLwd1a7syeM9OGk=";
  };

  vendorHash = "sha256-GkyRdDnokFlWIG5UMIUhA/QDpVgLPrGm6TS9CNXlHJI=";

  meta = with pkgs.lib; {
    description  =  "Quick sync, ssh and build on remote machines";
  };
}

