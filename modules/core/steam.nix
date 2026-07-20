{pkgs, lib, ...}: {
  programs = {
    steam = {
      enable = lib.mkForce true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;
      gamescopeSession.enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
      extraPackages = with pkgs; [
           mesa
           vulkan-tools
           gperftools
           libunwind
           libthai
           pipewire
           libpulseaudio
           alsa-lib
           alsa-plugins
      ];
    };

    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };

   gamemode.enable = true;
    
  };

}
