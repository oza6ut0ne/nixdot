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

          packagesFor =
            pkgs: directory:
            lib.packagesFromDirectoryRecursive {
              inherit (pkgs) callPackage;
              inherit directory;
            };

          pkgsCrossFor =
            crossSystem:
            import inputs.nixpkgs {
              inherit system crossSystem;
            };
        in
        {
          packages = packagesFor pkgs ./pkgs/cross // packagesFor pkgs ./pkgs/noCross;

          legacyPackages =
            # Static build
            lib.mapAttrs' (name: value: lib.nameValuePair (name + "-static") value) (
              packagesFor pkgs.pkgsStatic ./pkgs/cross
            )

            # Cross build
            // lib.foldl (acc: elem: acc // elem) { } (
              map (
                crossSystem:
                lib.mapAttrs' (name: value: lib.nameValuePair "${name}-cross-${crossSystem}" value) (
                  packagesFor (pkgsCrossFor crossSystem) ./pkgs/cross
                )
              ) crossSystems
            )

            # Static cross build
            // lib.foldl (acc: elem: acc // elem) { } (
              map (
                crossSystem:
                lib.mapAttrs' (name: value: lib.nameValuePair "${name}-static-${crossSystem}" value) (
                  packagesFor (pkgsCrossFor crossSystem).pkgsStatic ./pkgs/cross
                )
              ) crossSystems
            );
        };

      flake = {
        homeConfigurations.${builtins.getEnv "USER"} =
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
          in
          inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            modules = [
              ./home.nix
            ] ++ pkgs.lib.optionals localConfExists [ localConfFile ];

            extraSpecialArgs = {
              inherit username homeDirectory;
              inherit self;
              inherit (pkgs) system;
              inherit pkgsDot;
              inherit pkgsUnpin;
              inherit nixgl;
            };
          };
      };
    };
}
