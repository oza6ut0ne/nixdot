{
  description = "My nix configulations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } rec {
      imports = [
        inputs.home-manager.flakeModules.home-manager
      ];

      systems = [
        "x86_64-linux"
        "armv7l-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          lib,
          system,
          ...
        }:
        let
          crossSystems = systems ++ [
            "mipsel-linux-gnu"
          ];

          dotPackages = import ./. {
            inherit (inputs) nixpkgs;
            inherit
              pkgs
              crossSystems
              ;
          };
        in
        {
          inherit (dotPackages) packages legacyPackages;
        };

      flake = {
        homeConfigurations =
          let
            username = builtins.getEnv "USER";
            homeDirectory = builtins.getEnv "HOME";
            localConfFile = "${homeDirectory}/.home.local.nix";
            localConfExists = builtins.pathExists localConfFile;

            pkgs = import inputs.nixpkgs { config.allowUnfree = true; };
            pkgsDot = self.packages.${pkgs.system};
            pkgsUnpin = import (builtins.getFlake "github:NixOS/nixpkgs/nixpkgs-unstable") {
              config.allowUnfree = true;
            };
            nixgl = import inputs.nixgl { inherit pkgs; };

            extraSpecialArgs = {
              inherit username homeDirectory;
              inherit self;
              inherit (pkgs) system;
              inherit pkgsDot;
              inherit pkgsUnpin;
              inherit nixgl;
            };

            modulesBase = [
              ./home/common.nix
            ] ++ pkgs.lib.optionals localConfExists [ localConfFile ];
          in
          {
            ${builtins.getEnv "USER"} = inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs extraSpecialArgs;
              modules = modulesBase;
            };

            cli = inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs extraSpecialArgs;
              modules = modulesBase ++ [
                ./home/cli.nix
              ];
            };

            gui = inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs extraSpecialArgs;
              modules = modulesBase ++ [
                ./home/cli.nix
                ./home/gui.nix
              ];
            };
          };
      };
    };
}
