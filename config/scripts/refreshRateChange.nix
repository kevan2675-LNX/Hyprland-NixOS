{ pkgs, flakeDir, ... }:

pkgs.writeShellScriptBin "rateChanger" ''
rm /home/lucifer/.mozilla/firefox/lucifer/search.json.mozlz4.backup
rm  /home/lucifer/.mozilla/firefox/Guest/search.json.mozlz4.backup
rm  /home/lucifer/.mozilla/firefox/lucifer-work/search.json.mozlz4.backup

flakeDir=${flakeDir}
rate=$1
regex='^[0-9]+$'
if [ $# -eq 0 ]; then
  echo "please provide a refresh rate to apply"
  exit 1
fi
if [[ $rate =~ $regex ]]; then
  if [[ $rate -ge 60 && $rate -le 240 ]]; then
    sed -i "s/@[0-9]\+,/@$rate,/" $flakeDir/config/home/hyprland.nix
     sudo nixos-rebuild switch --flake "$flakeDir"
  else
    echo "Refresh Rate Not Within Limits (60Hz - 240Hz)";
  fi
else
  echo "Not an integer";
fi  
''
