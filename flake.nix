{
  description = "Lucifer's NIX";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-colors.url = "github:misterio77/nix-colors";
    ags.url = "github:/Aylur/ags/v1";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      type = "git";
      url = "https://github.com/Arana-Jayavihan/spicetify-nix.git";
      rev = "ade5f865a196b4b921dd953f505b0a66b658bc1d";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox = {
      type = "git";
      url = "https://github.com/nix-community/flake-firefox-nightly.git";
      rev = "5050ea18e1c329e158533a5e10dd0ab5289e557d";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = inputs@{ nixpkgs-stable, nixpkgs, home-manager, impermanence, nix-colors, spicetify-nix, firefox, ... }:
  let
    system = "x86_64-linux";
    inherit (import ./options.nix) username hostname;

    pkgs = import nixpkgs {
      inherit system;
      config = {
	    allowUnfree = true;
      };
    };

    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config = {
	    allowUnfree = true;
      };
    };

    nixColorsContrib = nix-colors.lib.contrib { inherit pkgs; };

  in {
    nixosConfigurations = {
      "${hostname}" = nixpkgs.lib.nixosSystem {
	specialArgs = { 
          inherit system; 
          inherit inputs; 
          inherit username; 
          inherit hostname;
          inherit pkgs-stable;
          inherit nixColorsContrib;
          inherit firefox;
        };
	modules = [ 
          ./system.nix
	  impermanence.nixosModules.impermanence
          home-manager.nixosModules.home-manager {
	    home-manager.extraSpecialArgs = {
              inherit username; 
              inherit inputs;
              inherit pkgs-stable;
              inherit nixColorsContrib;
              inherit spicetify-nix;
              inherit firefox;
            };
	    home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
	    home-manager.users.${username} = import ./home.nix;
	  }
	];
      };
    };
  };
}
