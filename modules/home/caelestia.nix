{inputs, ..}: {
  imports = [inputs.caelestia.homeModules.default];
  programs.caelestia = {
    enable = true;
    cli.enable = true;
  };
}
  
