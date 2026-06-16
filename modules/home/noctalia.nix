{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.noctalia.homeModules.default];

  programs.noctalia = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;

    settings = {
      plugins.colorSchemes = {
        predefinedScheme = "Catppuccin";
        darkMode = true;
      };
      wallpaper = {
        enabled = true;
        directory = "~/Pictures/Wallpapers";
      };
    };
  };
}
