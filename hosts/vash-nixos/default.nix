{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];

  nix.settings.access-tokens = [
    "github.com=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"
    ];

    home-manager.backupFileExtension = "backup";
}
