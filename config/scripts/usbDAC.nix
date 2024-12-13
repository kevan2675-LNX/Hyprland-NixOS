{ pkgs, ... }:

pkgs.writeShellScriptBin "usbDAC" ''
  sleep 1;
  ${pkgs.alsa-utils}/bin/amixer -c 0 set PCM 100% unmute -q;
  ${pkgs.alsa-utils}/bin/amixer -c 1 set PCM 100% unmute -q;
''
