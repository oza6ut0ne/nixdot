{
  description = "My nix configulations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } rec {
      imports = [ ];

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
            pkgs:
            lib.packagesFromDirectoryRecursive {
              inherit (pkgs) callPackage;
              directory = ./pkgs;
            };

          pkgsCrossFor =
            crossSystem:
            import inputs.nixpkgs {
              inherit system crossSystem;
            };
        in
        {
          packages = packagesFor pkgs;

          legacyPackages =
            # Static build
            lib.mapAttrs' (name: value: lib.nameValuePair (name + "-static") value) (
              packagesFor pkgs.pkgsStatic
            )

            # Cross build
            // lib.foldl (acc: elem: acc // elem) { } (
              map (
                crossSystem:
                lib.mapAttrs' (name: value: lib.nameValuePair "${name}-cross-${crossSystem}" value) (
                  packagesFor (pkgsCrossFor crossSystem)
                )
              ) crossSystems
            )

            # Static cross build
            // lib.foldl (acc: elem: acc // elem) { } (
              map (
                crossSystem:
                lib.mapAttrs' (name: value: lib.nameValuePair "${name}-static-${crossSystem}" value) (
                  packagesFor (pkgsCrossFor crossSystem).pkgsStatic
                )
              ) crossSystems
            );
        };

      flake = { };
    };
}
