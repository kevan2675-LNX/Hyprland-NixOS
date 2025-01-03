{ pkgs, inputs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List System Programs 
  programs = {
    steam.gamescopeSession.enable = true;
    dconf.enable = true;
    seahorse.enable=true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = true;
    };
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    virt-manager.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-media-tags-plugin
      ];
    };
    yazi = {
      enable = true;
    };
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    #qemu = {
    #  package = pkgs.qemu_kvm;
    #  runAsRoot = true;
    #  swtpm.enable = true; 
    #};
  };
}
