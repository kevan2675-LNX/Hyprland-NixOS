{ pkgs, config, lib, ... }:

let inherit (import ../../options.nix) gpuType; in
lib.mkIf ("${gpuType}" == "intel") {  
  # OpenGL
  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };
}
