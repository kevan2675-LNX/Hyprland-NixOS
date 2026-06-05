{ pkgs, config, lib, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    kernel.sysctl = { "vm.max_map_count" = 2147483642; };
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    plymouth.enable = true;
  };

   boot.kernelParams = [
    "i915.enable_guc=0"           # Wajib 0 untuk Skylake! Matikan GuC/HuC karena bikin driver tidak stabil
    "i915.enable_rc6=1"           # Aktifkan hemat daya GPU standar yang stabil
    "i915.reset=1"                # JIKA terjadi hang, paksa driver mereset GPU secara instan
  ];
    

}
