{pkgs, inputs, lib, ...}: let
  system = pkgs.stdenv.hostPlatform.system;
  caelestiaPkg = inputs.caelestia.packages.${system}.with-cli;
  caelestiaEntrypoint = pkgs.writeShellScript "caelestia-entrypoint" ''
    set -euo pipefail
    ${pkgs.procps}/bin/pkill -f noctalia-shell 2>/dev/null || true
    ${pkgs.coreutils}/bin/sleep 0.4
    exec ${caelestiaPkg}/bin/caelestia-shell
  '';
in {
  home.packages = with pkgs; [
  caelestiaPkg
  gtk4
  libadwaita
  python3
  uv
  pipx
  glib.bin
  ninja
  pkg-config
  cairo
  cairo.dev
  gcc
  gobject-introspection
  gobject-introspection.dev
  ];

  home.sessionVariables = {
    PKG_CONFIG_PATH = "${pkgs.cairo.dev}/lib/pkgconfig:${pkgs.gobject-introspection.dev}/lib/pkgconfig";
  };
  
  systemd.user.services.caelestia = {
    Unit.Description = "Caelestia shell";
    Service = {
      Type = "simple";
      ExecStart = "${caelestiaEntrypoint}";
      Restart = "on-failure";
    };
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = lib.mkForce "JetBrains Mono:size=10";
      };
      colors = {
        alpha = lib.mkForce 0.8;
      };
    };
  };
}
  
