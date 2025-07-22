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
    curl -Lo "''${cache_dir}/files.tmp" "https://github.com/nix-community/nix-index-database/releases/latest/download/''${filename}"
    if [ "$(stat -c%s "''${cache_dir}/files.tmp")" -lt 32 ]; then
      rm "''${cache_dir}/files.tmp"
      echo "''$filename download failed!"
      exit 1
    else
      if [[ -f ''${cache_dir}/files ]]; then
        cp "''${cache_dir}/files" "''${cache_dir}/files.bak"
      fi
      mv "''${cache_dir}/files.tmp" "''${cache_dir}/files"
    fi
  '';
}
