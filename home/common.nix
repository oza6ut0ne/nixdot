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
  targets.genericLinux.nixGL = {
    packages = if (lib.pathIsRegularFile "/etc/NIXOS") || system != "x86_64-linux" then null else nixgl;
    installScripts = [
      "mesa"
      "mesaPrime"
    ];
  };

  home.packages =
    (with pkgs; [
      comma
      nix-index

      nil
      nixfmt
      nix-output-monitor
      nix-search-cli
      nix-tree

      bat
      cmigemo
      fd
      fzf
      kakasi
      mmv-go
      mosh
      ripgrep
      tree-sitter
      unar
      zoxide
    ])
    ++ (with pkgsUnpin; [

    ])
    ++ (with pkgsDot; [
      nix-bundle-appimage
      nix-index-download-cache
      nix-version-search
      diff-highlight
    ])
    ++ lib.optionals (builtins.elem "nvidia" config.targets.genericLinux.nixGL.installScripts) [
      (config.lib.nixGL.wrap pkgs.nvitop)
    ];

  home.file = {
    ".config/skk/SKK-JISYO.nix.utf8".source = "${pkgsDot.skk-dicts}/share/skk/SKK-JISYO.merged.utf8";
  };

  home.sessionVariables = {

  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    neovim = {
      enable = true;
      sideloadInitLua = true;
      withPython3 = true;
      withNodeJs = true;
      extraPython3Packages = ps: with ps; [ debugpy ];
    };
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

    d = {
      exact = false;
      from = {
        id = "d";
        type = "indirect";
      };
      to = {
        id = "dot";
        type = "indirect";
      };
    };

    dotlocal = {
      exact = false;
      from = {
        id = "dl";
        type = "indirect";
      };
      to = {
        type = "path";
        path = "${homeDirectory}/nixdot";
      };
    };
  };

  nix.nixPath = [
    "nixpkgs=flake:nixpkgs"
    "n=flake:nixpkgs"
    "dot=flake:dot"
    "d=flake:d"
    "dl=flake:dl"
  ];

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}
