#!/usr/bin/env bash
# vim: ft=bash: ts=2

set -euo pipefail
if ! command -v nix >/dev/null; then
  cat << 'EOF'

Install Nix first!

(a) With offitial installer
  sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon --yes
  echo 'experimental-features = nix-command flakes' | sudo tee -a /etc/nix/nix.conf
  echo 'auto-optimise-store = true'                 | sudo tee -a /etc/nix/nix.conf
  echo 'bash-prompt-prefix = (nix:$name)\040'       | sudo tee -a /etc/nix/nix.conf
  echo 'max-jobs = auto'                            | sudo tee -a /etc/nix/nix.conf
  echo 'extra-nix-path = nixpkgs=flake:nixpkgs'     | sudo tee -a /etc/nix/nix.conf
  echo 'trusted-users = root @sudo @wheel'          | sudo tee -a /etc/nix/nix.conf
  sudo systemctl restart nix-daemon.service
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

(b) With Determinate System's installer
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --diagnostic-endpoint="" --no-confirm
  echo 'trusted-users = root @sudo @wheel'          | sudo tee -a /etc/nix/nix.conf
  sudo systemctl restart nix-daemon.service
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

(c) With Lix installer
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.lix.systems/lix | sh -s -- install --no-confirm
  echo 'trusted-users = root @sudo @wheel'          | sudo tee -a /etc/nix/nix.conf
  sudo systemctl restart nix-daemon.service
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  # Also need to install Git to run home-manager with Lix

(d) With nix-portable
  curl -L https://github.com/DavHau/nix-portable/releases/latest/download/nix-portable-$(uname -m) > ./nix-portable
  chmod +x ./nix-portable
  NP_RUNTIME=bwrap ./nix-portable nix shell nixpkgs#nix

EOF
  exit 1
fi

set -x

REPO_URL_NIXDOT=https://github.com/oza6ut0ne/nixdot.git
REPO_URL_DOTFILES=https://github.com/oza6ut0ne/dotfiles.git

REPO_DIR_NIXDOT=${HOME}/nixdot
REPO_DIR_DOTFILES=${HOME}/dotfiles
CONF_DIR_HOME_MANAGER=${HOME}/.config/home-manager

config_name=${1-}
if [[ -z $config_name ]]; then
  flake="."
else
  flake=".#$config_name"
fi

if command -v git >/dev/null; then
  GIT=git
else
  GIT="nix run nixpkgs#git --"
fi

if [[ ! -e $REPO_DIR_NIXDOT ]] && [[ ! -e $CONF_DIR_HOME_MANAGER ]]; then
  $GIT clone $REPO_URL_NIXDOT "$REPO_DIR_NIXDOT"
fi

if [[ -d $REPO_DIR_NIXDOT ]]; then
  cd "$REPO_DIR_NIXDOT"
  nix run home-manager -- switch --impure --flake "$flake"
elif [[ -d $CONF_DIR_HOME_MANAGER ]]; then
  cd "$CONF_DIR_HOME_MANAGER"
  nix run home-manager -- switch --impure --flake "$flake"
fi

if [[ ! -e $REPO_DIR_DOTFILES ]]; then
  $GIT clone $REPO_URL_DOTFILES "$REPO_DIR_DOTFILES"
  cd "$REPO_DIR_DOTFILES"

  if [[ -e ${HOME}/.bashrc ]] && [[ ! -e ${HOME}/.bashrc.org ]]; then
    cp "${HOME}/.bashrc" "${HOME}/.bashrc.org"
  fi
  ./deploy.sh
fi
