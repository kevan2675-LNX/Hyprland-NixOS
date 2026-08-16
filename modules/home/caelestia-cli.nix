{inputs, pkgs, ...}: let
  system = pkgs.stdenv.hostPlatform.system;
in {
  home.packages = [inputs.caelestia-cli.packages.${system}.default];
}
