#!/usr/bin/env bash
# vim: ft=bash: ts=2

set -euo pipefail

exists() {
  command -v "$1" >/dev/null
}

usage() {
  echo "Usage: ./install_nix.sh { official | determinate | lix | portable }"
}

if [ "$#" -ne 1 ]; then
  usage
  exit 1
fi

if exists nix; then
  echo "Nix is already installed"
  exit 2
fi

set -x
if exists sudo; then
  SUDO=sudo
else
  SUDO=
fi

if exists init && exists systemctl && systemctl status >/dev/null 2>&1; then
  SYSTEMD_ENABLED=1
else
  SYSTEMD_ENABLED=0
fi
set +x

main() {
  case "${1-}" in
    off*) install_official;;
    det*) install_determinate;;
    lix)  install_lix;;
    por*) install_portable;;
  esac
}

install_dependencies() {
  if exists curl && exists git && exists xz; then
    return
  fi

  if exists apt >/dev/null; then
    ${SUDO} apt update
    ${SUDO} apt install -y curl git xz-utils
    return
  fi

  if exists pacman >/dev/null; then
    ${SUDO} pacman -Syyu --noconfirm
    ${SUDO} pacman -S --noconfirm curl git xz
    return
  fi
}

install_official() {
  set -x
  install_dependencies

  sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon --yes
  echo 'experimental-features = nix-command flakes' | ${SUDO} tee -a /etc/nix/nix.conf
  echo 'auto-optimise-store = true'                 | ${SUDO} tee -a /etc/nix/nix.conf
  echo 'bash-prompt-prefix = (nix:$name)\040'       | ${SUDO} tee -a /etc/nix/nix.conf
  echo 'max-jobs = auto'                            | ${SUDO} tee -a /etc/nix/nix.conf
  echo 'extra-nix-path = nixpkgs=flake:nixpkgs'     | ${SUDO} tee -a /etc/nix/nix.conf
  echo 'trusted-users = root @sudo @wheel'          | ${SUDO} tee -a /etc/nix/nix.conf
  if [ "$SYSTEMD_ENABLED" = "1" ]; then
    ${SUDO} systemctl restart nix-daemon.service
  fi
  set +x

  echo To get started using Nix, open a new shell or run
  echo '`. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh`'
}

install_determinate() {
  set -x
  install_dependencies

  opts='--diagnostic-endpoint="" --no-confirm'
  if [ "$SYSTEMD_ENABLED" = "0" ]; then
    opts="${opts} --init none"
  fi

  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux ${opts}
  echo 'trusted-users = root @sudo @wheel'          | ${SUDO} tee -a /etc/nix/nix.conf

  if [ "$SYSTEMD_ENABLED" = "1" ]; then
    ${SUDO} systemctl restart nix-daemon.service
  fi
  set +x

  echo To get started using Nix, open a new shell or run
  echo '`. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh`'
}

install_lix() {
  set -x
  install_dependencies

  opts='--no-confirm'
  if [ "$SYSTEMD_ENABLED" = "0" ]; then
    opts="${opts} --init none"
  fi

  curl --proto '=https' --tlsv1.2 -sSf -L https://install.lix.systems/lix | sh -s -- install linux ${opts}
  echo 'trusted-users = root @sudo @wheel'          | ${SUDO} tee -a /etc/nix/nix.conf

  if [ "$SYSTEMD_ENABLED" = "1" ]; then
    ${SUDO} systemctl restart nix-daemon.service
  fi
  set +x

  echo To get started using Nix, open a new shell or run
  echo '`. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh`'
}

install_portable() {
  set -x
  install_dependencies

  curl -L https://github.com/DavHau/nix-portable/releases/latest/download/nix-portable-$(uname -m) > ./nix-portable
  chmod +x ./nix-portable
  set +x

  echo To get started using Nix, run
  if [ -f /.dockerenv ]; then
    echo '`NP_RUNTIME=proot ./nix-portable nix shell nixpkgs#nix`'
  else
    echo '`NP_RUNTIME=bwrap ./nix-portable nix shell nixpkgs#nix`'
  fi
}

main "$@"
