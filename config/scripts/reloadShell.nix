{ pkgs, ... }:

pkgs.writeShellScriptBin "reloadShell" ''
  ${pkgs.pulseeffects-legacy}/bin/pulseeffects -l Lucifer;
  ${pkgs.swaynotificationcenter}/bin/swaync-client -rs
  ${pkgs.ags}/bin/ags -q; ags
''
