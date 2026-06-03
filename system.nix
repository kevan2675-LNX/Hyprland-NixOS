 { config, pkgs, username, hostname, pkgs-unstable, lib, ... }:

let 
  inherit (import ./options.nix) 
    theLocale theTimezone gitUsername
    theShell theLCVariables theKBDLayout flakeDir
    httpProxy socksProxy firewallPorts useFirewall;
    gdk = pkgs.google-cloud-sdk.withExtraComponents( with pkgs.google-cloud-sdk.components; [
      gke-gcloud-auth-plugin
    ]);
in {
  imports =
    [
      ./hardware.nix # Pastikan fileSystems drive Steam kamu sudah di-copy ke sini dari hardware-configuration.nix lama
      ./config/system
    ];

  # ================================================================
  # UNTUK HARDWARE (DIAMBIL DARI CONFIGURATION.NIX LAMA)
  # ================================================================
	
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      vulkan-loader
      intel-media-driver
      intel-vaapi-driver
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa
      vulkan-loader
    ];
  };
	
  boot.kernelParams = [
    "i915.enable_guc=0"           # Wajib 0 untuk Skylake! Matikan GuC/HuC karena bikin driver tidak stabil
    "i915.enable_rc6=1"           # Aktifkan hemat daya GPU standar yang stabil
    "i915.reset=1"                # JIKA terjadi hang, paksa driver mereset GPU secara instan
  ];

 # boot.kernel.sysctl = {
   # "vm.max_map_count" = 2147483642; # Wajib untuk alokasi memori game (Vulkan/Steam)
  #};

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.systemd-boot.edk2-uefi-shell.enable = false;  

  # KERNEL ZEN (PERFORMA LEBIH ENTENG)
  #boot.kernelPackages = pkgs.linuxPackages_zen;

  # ================================================================
  # NETWORKING & LOKALISASI
  # ================================================================

  networking.hostName = "${hostname}";
  networking.networkmanager.enable = true;
  networking.proxy.default = "${socksProxy}";
  
  # Nameserver & Hosts (TKJ Setup)
  networking.nameservers = ["165.22.52.204"];
  networking.extraHosts = ''
    165.22.52.204  simple-web.me
  '';

  # Firewall
  networking.firewall.enable = useFirewall;
  networking.firewall.allowedTCPPorts = if useFirewall == true then firewallPorts else [];

  time.timeZone = "${theTimezone}";
  i18n.defaultLocale = "${theLocale}";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "${theLCVariables}";
    LC_IDENTIFICATION = "${theLCVariables}";
    LC_MEASUREMENT = "${theLCVariables}";
    LC_MONETARY = "${theLCVariables}";
    LC_NAME = "${theLCVariables}";
    LC_NUMERIC = "${theLCVariables}";
    LC_PAPER = "${theLCVariables}";
    LC_TELEPHONE = "${theLCVariables}";
    LC_TIME = "${theLCVariables}";
  };
  console.keyMap = "${theKBDLayout}";

  # ================================================================
  # DESKTOP ENVIRONMENT & SESSION
  # ================================================================

  # SDDM & Hyprland (KDE PLASMA DIMATIKAN AGAR TIDAK BERAT)
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.plasma6.enable = true; # Dihapus/Matikan karena pindah ke Hyprland

  programs.hyprland.enable = true;

  #programs.ags = {
   #  enable = true;
    # configDir = ./config/home/files/ags;
  #};
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Memaksa aplikasi Electron (Discord/VSCode) jalan di Wayland
  };

  # ================================================================
  # USER ACCOUNT & PACKAGES
  # ================================================================

  users = {
    mutableUsers = true;
    users."${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" "audio" "pulse-access" "qemu-libvirtd" "kvm" "wireshark" "dialout" "input" ];
      hashedPassword = "$6$2X8wFfgCx6RDjSzR$MLtESVLeXi.jrAXczi9P5ZX/5CgBTKtwh7/XgINLxMBxHHsRY5Usr43.UzS.FqNtxRRyr2dIRMmrCLu8iayr7.";
      shell = pkgs.${theShell};
      ignoreShellProgramCheck = true;
      
      packages = (with pkgs; [ 
        # --- APLIKASI LUCIFER STABLE ---
        gcc             # Compiler bahasa C
        openssl         # Toolkit keamanan & enkripsi
        netcat          # Tool networking buat kirim data
        gnupg           # Pengelola kunci enkripsi (PGP)
        railway         # Tool buat deployment ke cloud
        nmap            # Scanner jaringan (Wajib buat TKJ)
        gobuster        # Brute-force URL/DNS
        dex2jar         # Tool buat bongkar file .dex Android ke .jar
        tshark          # Versi terminal dari Wireshark
        sshpass         # Auto-input password SSH
        inetutils       # Kumpulan tool network dasar
        netdiscover     # Tool buat cari IP di jaringan lokal
        exiftool        # Editor metadata gambar/file
        hexedit         # Editor file biner (Hex)
        binwalk         # Tool analisis firmware/file tersembunyi
        dig             # Tool buat cek DNS
        stunnel         # Proxy buat bungkus traffic dengan TLS/SSL
        enum4linux-ng   # Tool enumerasi Windows/Samba
        zip             # Pengarsip file
        mangohud        # Overlay performa buat game
        lutris          # Launcher game Linux
        tcptraceroute   # Traceroute lewat protokol TCP
        hyprpicker      # Color picker buat Wayland
        zed-editor      # Text editor super cepat
        gdk             # Google Cloud SDK (Development)

        # --- APLIKASI KAMU (DARI CONFIG LAMA) ---
        kdePackages.kate # Editor teks favorit kamu
        brave           # Browser utama
        discord         # Chat
        ciscoPacketTracer8 # Simulasi jaringan TKJ
        arduino-ide     # Coding hardware
        python3         # Bahasa pemrograman
      ])

      ++

      (with pkgs-unstable; [
        # --- APLIKASI LUCIFER UNSTABLE ---
        qbittorrent     # Download torrent
        xz              # Alat kompresi file
        sysstat         # Monitor sistem (sar, iostat)
        dmidecode       # Cek info hardware (BIOS, RAM) lewat terminal
        textsnatcher    # OCR: Ambil teks dari gambar di layar
        hdparm          # Atur parameter hardisk
        pwninit         # Tool buat CTF/Exploit development
        gef             # Plugin GDB buat debugging exploit
        patchelf        # Ubah rpath di file ELF (biner Linux)
        scrcpy          # Remote layar Android ke laptop
        virtiofsd       # File system sharing buat VM
        spice-gtk       # Display client buat Virtual Machine
        cbonsai         # Hiasan terminal bentuk pohon bonsai
        peaclock        # Jam cantik di terminal
        nixpkgs-fmt     # Formatter file Nix
        csvlens         # Viewer file CSV di terminal
        marktext        # Editor Markdown cantik
        cava            # Visualizer audio di terminal
        wev             # Monitor event input di Wayland
        screen          # Terminal multiplexer (sesi terminal)
        jq              # Tool buat proses data JSON
        tmux            # Alternatif screen yang lebih modern
        starship
      ]);
    };
  };

  # ================================================================
  # SYSTEM PACKAGES (GABUNGAN)
  # ================================================================

  environment.systemPackages = (with pkgs; [
    # Dasar & Networking
    curl git pciutils wget file nasm tcpdump parted nh nvd
    
    # Audio
    pulseaudioFull pavucontrol pulseeffects-legacy alsa-utils
    
    # Monitor & Hardware
    htop btop lm_sensors lshw brightnessctl toybox
    
    # Virtualisasi & GUI Tool
    libvirt polkit_gnome virt-viewer swappy ripgrep 
    unzip unrar libnotify v4l-utils ydotool wl-clipboard socat lsd 
    appimage-run networkmanagerapplet yad playerctl fastfetch libcec zoxide
    gparted aircrack-ng ntfs3g proxychains-ng
    
    # Compiler & Tooling
    pkg-config meson gnumake ninja go nodejs

    # Bahan Zsh kamu
    zsh-autosuggestions zsh-completions zsh-syntax-highlighting
  ]);

  # ================================================================
  # SERVICES & OPTIMIZATIONS (PENTING BUAT THINKPAD T460)
  # ================================================================

  # TLP (Settingan Baterai Kamu)
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC="powersave";
      CPU_SCALING_GOVERNOR_ON_BAT="powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC="balance_performance"; 
      CPU_ENERGY_PERF_POLICY_ON_BAT="balance_power";
      CPU_MAX_PERF_ON_AC=90;
      CPU_MAX_PERF_ON_BAT=80;
      CPU_BOOST_ON_AC=1;
      CPU_BOOST_ON_BAT=0;
      MEM_SLEEP_ON_AC="deep";
      MEM_SLEEP_ON_BAT="deep";
      DISK_APM_LEVEL_ON_AC="254 254";
      DISK_APM_LEVEL_ON_BAT="128 128";
      USB_AUTOSUSPEND=1;
    };
  };

  # Undervolt (Agar CPU Dingin)
  services.undervolt = {
    enable = true;
    coreOffset = -80;
    gpuOffset = -50;
    uncoreOffset = -80;
    temp = 90;
  };

  # Zram (Swap di RAM agar tidak lemot)
  zramSwap = {
    enable = true;
    priority = 100;
    memoryPercent = 50;
  };

  services.power-profiles-daemon.enable = lib.mkForce false; # Wajib OFF agar TLP jalan

  # Steam & Gaming
  programs.steam = {
    enable = lib.mkForce true;
    remotePlay.openFirewall = true; 
    dedicatedServer.openFirewall = true;
    extraPackages = with pkgs; [
      mesa vulkan-tools gperftools libunwind libthai
    ];
  };

  # Zsh Config (Prompt & Menu kamu)
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    interactiveShellInit = ''
      zstyle ':completion:*' menu select
      bindkey '^[[Z' reverse-menu-complete
      PROMPT='%n@%m:%~ > '
    '';
  };

  # Nix-LD (Buat jalanin program luar)
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ libcap stdenv.cc.cc openssl ];

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      ubuntu-classic nerd-fonts.jetbrains-mono font-awesome noto-fonts-color-emoji material-icons
    ];
    fontDir.enable = true;
  };

  # Virtualisasi
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = false;
  virtualisation.waydroid.enable = false; # Dimatikan agar storage tidak penuh (berat!)

  # ================================================================
  # NIX SETTINGS & GC
  # ================================================================

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "ciscoPacketTracer8-8.2.2" "ventoy" ];
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  system.stateVersion = "25.11"; # Sesuaikan dengan stateVersion configuration.nix lama kamu
}
