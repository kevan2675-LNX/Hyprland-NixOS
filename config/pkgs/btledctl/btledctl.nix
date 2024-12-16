{ pkgs, ... }:

{
  btledctl = pkgs.stdenv.mkDerivation rec {
    pname = "btledctl";
    version = "1.0";
    src = ./.;

    buildInputs = with pkgs.python3Packages; [
      bleak
      pyinstaller
    ];

    buildPhase = ''
      pyinstaller -F btledctl.py
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp ./dist/btledctl $out/bin
    '';

    doCheck = false;
  };
}
