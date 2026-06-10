{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
  udiskie
  parted
  ntfs3g
  ];
}
