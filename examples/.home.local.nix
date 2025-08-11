args@{
  self,
  config,
  lib,
  system,
  pkgs,
  pkgsDot,
  pkgsUnpin,
  nixgl,
  usrename,
  homeDirectory,
  ...
}:

let
  pkgsStable = import (builtins.getFlake "github:NixOS/nixpkgs/release-25.05") { };
  pkgsTts = (builtins.getFlake "github:oza6ut0ne/tts-server").packages.${system};
in
{
  # nixGL.defaultWrapper = "nvidia";
  # nixGL.offloadWrapper = "nvidiaPrime";
  # nixGL.installScripts = [
  #   "nvidia"
  #   "nvidiaPrime"
  # ];

  home.packages =
    (with pkgs; [
      # pkgsTts.tts
      # (config.lib.nixGL.wrap alacritty)
    ])
    ++ (with pkgsUnpin; [

    ])
    ++ (with pkgsDot; [

    ]);

  home.file = {
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    # EDITOR = "vim";
    # PROMPT_ONELINE = 0;
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
