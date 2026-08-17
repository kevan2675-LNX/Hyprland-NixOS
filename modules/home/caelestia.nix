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
        font = lib.mkForce "JetBrains Mono:size=13";  # naikin/turunin angka size buat gedein/kecilin
        pad = "16x16";  # ini yang benerin teks dempet ke tepi
      };
      "colors-dark" = {
        alpha = 0.85;
        background = "1e1e2e"; foreground = "cdd6f4";
        regular0 = "45475a"; regular1 = "f38ba8"; regular2 = "a6e3a1"; regular3 = "f9e2af";
        regular4 = "89b4fa"; regular5 = "f5c2e7"; regular6 = "94e2d5"; regular7 = "bac2de";
        bright0 = "585b70"; bright1 = "f38ba8"; bright2 = "a6e3a1"; bright3 = "f9e2af";
        bright4 = "89b4fa"; bright5 = "f5c2e7"; bright6 = "94e2d5"; bright7 = "a6adc8";
      };
      "colors-light" = {
        alpha = 0.85;
        background = "eff1f5"; foreground = "4c4f69";
        regular0 = "5c5f77"; regular1 = "d20f39"; regular2 = "40a02b"; regular3 = "df8e1d";
        regular4 = "1e66f5"; regular5 = "ea76cb"; regular6 = "179299"; regular7 = "acb0be";
        bright0 = "6c6f85"; bright1 = "d20f39"; bright2 = "40a02b"; bright3 = "df8e1d";
        bright4 = "1e66f5"; bright5 = "ea76cb"; bright6 = "179299"; bright7 = "bcc0cc";
      };
    };
  };
  
}
  
