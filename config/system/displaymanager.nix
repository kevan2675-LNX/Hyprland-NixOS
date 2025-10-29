{ pkgs, config, ... }:

let inherit (import ../../options.nix) theKBDVariant
theKBDLayout theSecondKBDLayout; in
{
  services.xserver = {
    enable = true;
    xkb = {
      variant = "${theKBDVariant}";
      layout = "${theKBDLayout}, ${theSecondKBDLayout}";
    };

    #displayManager.sddm = {
    #  enable = true;
    #  autoNumlock = true;
    #  wayland.enable = true;
    #  theme = "sddm-firewatch";
    #};
    desktopManager.gnome.enable = true;    
  };

  services.displayManager = {
    enable = true;
    sddm = {
      enable = true;
      wayland = {
        enable = true;
      };
      theme = "sddm-adaptive-theme";
      autoNumlock = true;
    };
  };

  services.libinput.enable = true;

  environment.systemPackages =
let
    sugar = pkgs.callPackage ../pkgs/sddm-sugar-dark.nix {};
    tokyo-night = pkgs.libsForQt5.callPackage ../pkgs/sddm-tokyo-night.nix {};
    sddm-adaptive-theme = pkgs.callPackage ../pkgs/sddm-theme/default.nix { inherit pkgs; };
in [ 
    sugar.sddm-sugar-dark # Name: sugar-dark
    tokyo-night # Name: tokyo-night-sddm
    sddm-adaptive-theme # Name sddm-adaptive-theme
    pkgs.libsForQt5.qt5.qtgraphicaleffects
  ];
}
