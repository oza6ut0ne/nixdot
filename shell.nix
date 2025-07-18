{
  pkgs ? import ./nixpkgs.nix { },
}:

pkgs.mkShellNoCC {
  NIX_CONFIG = "extra-experimental-features = nix-command flakes";
  nativeBuildInputs = with pkgs; [
    bashInteractive
    curl
    git
    vim
  ];
}
