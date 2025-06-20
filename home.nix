{
  self,
  config,
  lib,
  system,
  pkgs,
  pkgsDot,
  username,
  homeDirectory,
  ...
}:

{
  home.packages = with pkgs; [

  ];

  home.file = {

  };

  home.sessionVariables = {

  };

  programs = {

  };

  services = {

  };

  systemd.user.services = {

  };

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
