{ pkgs, ... }:

pkgs.writeShellScriptBin "reloadShell" ''
  kill -9 $(ps -eaf | grep ags-wrapped | awk '{print $2}' | xargs)
  ${pkgs.swaynotificationcenter}/bin/swaync-client -rs
  ${pkgs.ags}/bin/ags -q; ags
''
