{pkgs, lib, ...}: {
  programs.obs-studio = {
    enable = true;
    #enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-pipewire-audio-capture
      obs-vkcapture
      obs-source-clone
      obs-move-transition
      obs-composite-blur
      obs-backgroundremoval
      obs-vaapi
    ];
  };
  
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    config.common.default = lib.mkForce [ "hyprland"];
    };
}
