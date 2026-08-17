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

  home.activation.ensureHyprmodGuiConf = lib.hm.dag.entryAfter ["writeBoundary"] ''
    set -eu
    FILE="$HOME/.config/hypr/hyprland-gui.conf"
    if [ ! -f "$FILE" ]; then
      mkdir -p "$(dirname "$FILE")"
      $DRY_RUN_CMD touch "$FILE"
    fi
  '';

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      return {
        font = wezterm.font 'JetBrains Mono',
        font_size = 13.0,
        window_background_opacity = 0.85,
        enable_tab_bar = false,
      }
    '';
  };
}
