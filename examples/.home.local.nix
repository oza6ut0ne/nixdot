args@{
  self,
  config,
  lib,
  system,
  pkgs,
  pkgsDot,
  pkgsUnpin,
  usrename,
  homeDirectory,
  ...
}:

let
  pkgsStable = (builtins.getFlake "github:NixOS/nixpkgs/release-25.05").legacyPackages.${system};
  pkgsTts = (builtins.getFlake "github:oza6ut0ne/tts-server").packages.${system};
in
{
  home.packages =
    (with pkgs; [
      # pkgsTts.tts
    ])
    ++ (with pkgsUnpin; [

    ])
    ++ (with pkgsDot; [

    ]);

  home.file = {
    # ".screenrc".source = dotfiles/screenrc;
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    # EDITOR = "vim";
    # PROMPT_SHORT_PATH = 0;
    # PROMPT_GIT_STATUS = 0;
    # PROMPT_HOST_LABEL = "@";
  };

  programs = {

  };

  services = {

  };

  systemd.user.services = {

  };

  nix.registry = {

  };

  home.activation = {

  };
}
