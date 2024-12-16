{ pkgs, ... }:
{
  environment.systemPackages = let 
    schemer = pkgs.callPackage ../pkgs/schemer.nix {};
    btledctl = pkgs.callPackage ../pkgs/btledctl/btledctl.nix {};
  in [
    schemer.schemer
    btledctl.btledctl
  ];
}
