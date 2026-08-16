{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];

    home-manager.backupFileExtension = "backup";
}
