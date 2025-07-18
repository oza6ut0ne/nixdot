{
  nixpkgs ? import ../nixpkgs.nix,
  pkgs ? nixpkgs { },
  lib ? pkgs.lib,
  crossSystems,
}:

let
  packagesFor =
    pkgs: directory:
    lib.packagesFromDirectoryRecursive {
      inherit (pkgs) callPackage;
      inherit directory;
    };

  pkgsCrossFor =
    crossSystem:
    import nixpkgs {
      inherit (pkgs) system;
      inherit crossSystem;
    };
in
{
  packages = packagesFor pkgs ./cross // packagesFor pkgs ./noCross;

  legacyPackages =
    # Static build
    lib.mapAttrs' (name: value: lib.nameValuePair (name + "-static") value) (
      packagesFor pkgs.pkgsStatic ./cross
    )

    # Cross build
    // lib.foldl (acc: elem: acc // elem) { } (
      map (
        crossSystem:
        lib.mapAttrs' (name: value: lib.nameValuePair "${name}-cross-${crossSystem}" value) (
          packagesFor (pkgsCrossFor crossSystem) ./cross
        )
      ) crossSystems
    )

    # Static cross build
    // lib.foldl (acc: elem: acc // elem) { } (
      map (
        crossSystem:
        lib.mapAttrs' (name: value: lib.nameValuePair "${name}-static-${crossSystem}" value) (
          packagesFor (pkgsCrossFor crossSystem).pkgsStatic ./cross
        )
      ) crossSystems
    );
}
