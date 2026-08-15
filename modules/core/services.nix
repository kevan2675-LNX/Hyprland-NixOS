{profile, lib, ...}: {
  # Services to start
  services = {
    upower.enable = true; # noctalia shell battery
    libinput.enable = true; # Input Handling
    fstrim.enable = true; # SSD Optimizer
    gvfs.enable = true; # For Mounting USB & More
    power-profiles-daemon.enable = lib.mkForce false;
    openssh = {
      enable = false; # Enable SSH
      settings = {
        PermitRootLogin = "no"; # Prevent root from SSH login
        PasswordAuthentication = true; #Users can SSH using kb and password
        KbdInteractiveAuthentication = true;
      };
      ports = [22];
    };
    blueman.enable = true; # Bluetooth Support
    tumbler.enable = true; # Image/video preview
    gnome.gnome-keyring.enable = true;

    smartd = {
      enable =
        if profile == "vm"
        then false
        else true;
      autodetect = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      extraConfig.pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 256;
          "default.clock.min-quantum" = 256;
          "default.clock.max-quantum" = 256;
        };
      };
      extraConfig.pipewire-pulse."92-low-latency" = {
        context.modules = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              pulse.min.req = "256/48000";
              pulse.default.req = "256/48000";
              pulse.max.req = "256/48000";
              pulse.min.quantum = "256/48000";
              pulse.max.quantum = "256/48000";
            };
          }
        ];
      };
    };
  };


#================================
#==========SERVICES==============
#================================
   # TLP (Battery Setting)
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC="schedutil";
      CPU_SCALING_GOVERNOR_ON_BAT="powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC="balance_performance"; 
      CPU_ENERGY_PERF_POLICY_ON_BAT="balance_power";
      CPU_MAX_PERF_ON_AC=100;
      CPU_MAX_PERF_ON_BAT=80;
      CPU_BOOST_ON_AC=1;
      CPU_BOOST_ON_BAT=0;
      MEM_SLEEP_ON_AC="deep";
      MEM_SLEEP_ON_BAT="deep";
      DISK_APM_LEVEL_ON_AC="254 254";
      DISK_APM_LEVEL_ON_BAT="128 128";
      USB_AUTOSUSPEND=0;
      USB_DENYLIST ="usbhid";
      START_CHARGE_THRESH_BAT0=80;
      STOP_CHARGE_THRESH_BAT0=90;
      START_CHARGE_THRESH_BAT1=80;
      STOP_CHARGE_THRESH_BAT1=90;
  
      PCIE_ASPM_ON_AC = "performance";   
      PCIE_ASPM_ON_BAT = "powersupersave";
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
      SATA_LINKPWR_ON_AC = "max_performance";
      SATA_LINKPWR_ON_BAT = "min_power";
      RUNTIME_PM_ON_AC = "on";           # jamin gak ada PCI device di-runtime-suspend pas AC
      RUNTIME_PM_ON_BAT = "auto";
    };
  };

  services.thermald.enable = true;

    # Undervolt
  services.undervolt = {
    enable = true;
    coreOffset = -50;
    gpuOffset = -30;
    uncoreOffset = -50;
    temp = 90;
  };

  services.udisks2.enable = true;
  
  programs.kdeconnect.enable = true;
   networking.firewall = {
     allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
     allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
  };

  security.rtkit.enable = true;

  programs.gamemode.settings = {
    general.renice = 10;
    general.inhibit_screensaver = 1;
  };
  
}
