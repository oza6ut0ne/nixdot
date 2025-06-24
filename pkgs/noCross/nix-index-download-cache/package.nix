{
  writeShellApplication,
  curl,
}:

# https://github.com/nix-community/nix-index-database#ad-hoc-download
writeShellApplication {
  name = "nix-index-download-cache";

  runtimeInputs = [ curl ];

  text = ''
    cache_dir="''${NIX_INDEX_CACHE_DIR:-''${HOME}/.cache/nix-index}"
    filename="index-$(uname -m | sed 's/^arm64$/aarch64/')-$(uname | tr '[:upper:]' '[:lower:]')"
    mkdir -p "''${cache_dir}"

    set -x
    curl -Lo "''${cache_dir}/files" "https://github.com/nix-community/nix-index-database/releases/latest/download/''${filename}"
  '';
}
