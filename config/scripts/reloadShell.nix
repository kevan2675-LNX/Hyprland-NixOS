{ pkgs, ... }:

pkgs.writeShellScriptBin "reloadShell" ''
  ${pkgs.swaynotificationcenter}/bin/swaync-client -rs
  ${pkgs.ags}/bin/ags -q; ags
''
