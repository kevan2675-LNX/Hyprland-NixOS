{pkgs, inputs, lib, ...}: let
  system = pkgs.stdenv.hostPlatform.system;
  caelestiaPkg = inputs.caelestia.packages.${system}.with-cli;
  hyprmodPkg = inputs.hyprmod.packages.${system}.default;
  caelestiaEntrypoint = pkgs.writeShellScript "caelestia-entrypoint" ''
    set -euo pipefail
    ${pkgs.procps}/bin/pkill -f noctalia-shell 2>/dev/null || true
    ${pkgs.coreutils}/bin/sleep 0.4
    exec ${caelestiaPkg}/bin/caelestia-shell
  '';
in {
  home.packages = [
    caelestiaPkg
    hyprmodPkg
    (pkgs.writeShellScriptBin "hyprmod-caelestia" ''
      if systemctl --user is-active --quiet caelestia; then
        exec ${hyprmodPkg}/bin/hyprmod
      else
        ${pkgs.libnotify}/bin/notify-send "HyprMod" "Moving to Caelestia (Super+F1)"
      fi
    '')
  ];

  systemd.user.services.caelestia = {
    Unit.Description = "Caelestia shell";
    Service = {
      Type = "simple";
      ExecStart = "${caelestiaEntrypoint}";
      Restart = "on-failure";
    };
  };

  # HyprMod nulis config-nya sendiri ke sini — pastiin file-nya ada sebelum di-source
  home.activation.ensureHyprmodGuiConf = lib.hm.dag.entryAfter ["writeBoundary"] ''
    set -eu
    FILE="$HOME/.config/hypr/hyprland-gui.conf"
    if [ ! -f "$FILE" ]; then
      mkdir -p "$(dirname "$FILE")"
      $DRY_RUN_CMD touch "$FILE"
    fi
  '';

  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = lib.mkForce "JetBrains Mono:size=10";
      };
      colors.alpha = lib.mkForce 0.8;
    };
  };
}
  
