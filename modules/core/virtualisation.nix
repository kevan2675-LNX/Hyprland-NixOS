{pkgs, ...}: {
  # Only enable either docker or podman -- Not both
  virtualisation = {
    docker = {
      enable = false;
    };

    podman.enable = false;

    libvirtd = {
      enable = false;
    };

    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };
  };

  programs = {
    virt-manager.enable = false;
  };

  environment.systemPackages = with pkgs; [
    virt-viewer # View Virtual Machines
    lazydocker
    docker-client
  ];

   virtualisation.vmware.host.enable = true;
 
   users.users.vashlinux = {
   isNormalUser = true;
   extraGroups = [ "wheel" "networkmanager" "audio" "vboxusers" ];
  };

  #For NiXOS Permission Interfaces Host-Ony
  networking.interfaces.vboxnet0.ipv4.addresses = [ {
  address = "192.168.56.1";
  prefixLength = 24;
  } ];
 
}
