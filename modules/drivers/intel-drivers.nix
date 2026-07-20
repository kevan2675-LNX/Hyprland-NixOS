{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.drivers.intel;
in {
  options.drivers.intel = {
    enable = mkEnableOption "Enable Intel Graphics Drivers";
  };

  config = mkIf cfg.enable {
    # Vulkan
    hardware.graphics = {
    enable = true;
    enable32Bit = true;
      extraPackages = with pkgs; [
        intel-compute-runtime
        mesa
        intel-media-driver
      ];
    };
  };
}
