{ pkgs, wallpaperDir, ... }:

pkgs.writeShellScriptBin "wallSelector" ''
  chosen=$(ls /home/vashlinux/Projects/nix-wallpapers/|${pkgs.rofi}/bin/rofi -dmenu -p "Select a wallpaper")

  [ -z "$chosen" ] && exit;

  ${pkgs.swww}/bin/swww img ${wallpaperDir}/$chosen
''
