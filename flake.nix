{
  description = "My nix configulations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];

      systems =
        [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages = rec {
          open-jtalk =
            pkgs.callPackage ./pkgs/open-jtalk { inherit hts-engine; };

          hts-engine = pkgs.callPackage ./pkgs/hts-engine { };
        };
      };

      flake = { };
    };
}
