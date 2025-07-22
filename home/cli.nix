{
  self,
  config,
  lib,
  system,
  pkgs,
  pkgsDot,
  pkgsUnpin,
  nixgl,
  username,
  homeDirectory,
  ...
}:
{
  home.packages =
    (with pkgs; [
      aichat
      aria2
      gh
      ghq
      jujutsu
      mosquitto
      mqttui
      mutagen
      pssh
      rbw
      speedtest-cli
      starship
      tea
      xpra
    ])
    ++ (with pkgsUnpin; [

    ])
    ++ (with pkgsDot; [

    ]);

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

  home.activation = {

  };
}
