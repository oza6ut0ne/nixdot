{
  nixpkgs ? import <nixpkgs>,
  pkgs ? nixpkgs { },
  crossSystems ? [
    "x86_64-linux"
    "armv7l-linux"
    "aarch64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
    "mipsel-linux-gnu"
  ],
}:
let
  dotPackages = import ./pkgs {
    inherit nixpkgs pkgs crossSystems;
    inherit (pkgs) lib;
  };
in
dotPackages // dotPackages.packages // dotPackages.legacyPackages
