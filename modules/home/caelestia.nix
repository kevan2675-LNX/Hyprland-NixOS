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
  home.packages = [caelestiaPkg];
  systemd.user.services.caelestia = {
    Unit.Description = "Caelestia shell";
    Service = {
      Type = "simple";
      ExecStart = "${caelestiaEntrypoint}";
      Restart = "on-failure";
    };
  };

  gtk = {
        enable = true;
        iconTheme.package = lib.mkForce pkgs.papirus-icon-theme;
        iconTheme.name = lib.mkForce "Papirus-Dark";
  };
}
  
