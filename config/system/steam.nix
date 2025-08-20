{ pkgs, config, lib, ... }:

{
  # Steam Configuration
  programs.steam = {
    enable = false;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    protontricks.enable = true;
    extest.enable = true;
  };
}
