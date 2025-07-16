{
  writeShellApplication,
}:

writeShellApplication {
  name = "nix-bundle-appimage";

  text = ''
    nix bundle --bundler github:ralismark/nix-appimage "$@"
  '';
}
