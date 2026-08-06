{
  pkgs,
  host,
  ...
}: let
  inherit (import ../../hosts/${host}/variables.nix) stylixImage;
in {
  # Styling Options
  stylix = {
    enable = true;
    image = stylixImage;
    targets.kmscon.enable = false;
    targets.chromium.enable = false;
    #targets.console.enable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    polarity = "dark";
    opacity.terminal = 1.0;
    cursor = {
  package = pkgs.runCommand "custom-cursor" {} ''
    export HOME=$(mktemp -d)
    mkdir -p $out/share/icons
    cp -r ${../../assets/eram-cursor-linux} $out/share/icons/eram-cursor-linux 
  '';
  name = "eram-cursor-linux";
  size = 22;
};

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };
  
}
