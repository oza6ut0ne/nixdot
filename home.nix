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

  home.activation = {
    linkToHomeManagerConfigDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      src_dir="${homeDirectory}/nixdot"
      dst_dir="${config.xdg.configHome}/home-manager"
      if [ -d "''${src_dir}" ] && [ ! -d "''${dst_dir}" ]; then
        run ln $VERBOSE_ARG -sT "''${src_dir}" "''${dst_dir}"
      fi
    '';
  };

  nix.registry = {
    n = {
      exact = false;
      from = {
        id = "n";
        type = "indirect";
      };
      to = {
        id = "nixpkgs";
        type = "indirect";
      };
    };

    dot = {
      exact = false;
      from = {
        id = "dot";
        type = "indirect";
      };
      to = {
        owner = "oza6ut0ne";
        repo = "nixdot";
        type = "github";
      };
    };

    dotlocal = {
      exact = false;
      from = {
        id = "dotlocal";
        type = "indirect";
      };
      to = {
        type = "path";
        path = "${homeDirectory}/nixdot";
      };
    };
  };

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
