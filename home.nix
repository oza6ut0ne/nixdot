{
  self,
  config,
  lib,
  system,
  pkgs,
  pkgsDot,
  pkgsUnpin,
  username,
  homeDirectory,
  ...
}:
{
  home.packages =
    (with pkgs; [
      comma
      nix-index
      pkgsDot.nix-index-download-cache

      nil
      nixfmt-rfc-style
      nix-search-cli
      pkgsDot.nix-version-search
    ])
    ++ (with pkgsUnpin; [

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
    cloneRepository = ''
      repo_dir="${homeDirectory}/nixdot"
      conf_dir="${config.xdg.configHome}/home-manager"
      if [ ! -e "''${repo_dir}" ] && [ ! -e "''${conf_dir}" ]; then
        run "${pkgs.git}/bin/git" clone $VERBOSE_ARG https://github.com/oza6ut0ne/nixdot.git "''${repo_dir}"
      fi
    '';

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
