{ pkgs, flakeDir, ... }:

pkgs.writeShellScriptBin "rebuild" ''
rm /home/lucifer/.mozilla/firefox/lucifer/search.json.mozlz4.backup
rm  /home/lucifer/.mozilla/firefox/Guest/search.json.mozlz4.backup
rm  /home/lucifer/.mozilla/firefox/lucifer-work/search.json.mozlz4.backup

cd ${flakeDir}

# Git Add
git add .

# NixOS Rebuild
sudo nixos-rebuild switch --flake .
''
