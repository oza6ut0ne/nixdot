#!/usr/bin/env bash
# vim: ft=bash: ts=2

set -euo pipefail
set -x

REPO_URL_NIXDOT=https://github.com/oza6ut0ne/nixdot.git
REPO_URL_DOTFILES=https://github.com/oza6ut0ne/dotfiles.git

REPO_DIR_NIXDOT=${HOME}/nixdot
REPO_DIR_DOTFILES=${HOME}/dotfiles
CONF_DIR_HOME_MANAGER=${HOME}/.config/home-manager

GIT="nix run nixpkgs#git --"

if [[ ! -e $REPO_DIR_NIXDOT ]] && [[ ! -e $CONF_DIR_HOME_MANAGER ]]; then
  $GIT clone $REPO_URL_NIXDOT "$REPO_DIR_NIXDOT"
fi

if [[ -d $REPO_DIR_NIXDOT ]]; then
  cd "$REPO_DIR_NIXDOT"
  nix run home-manager -- --impure --flake . switch
elif [[ -d $CONF_DIR_HOME_MANAGER ]]; then
  cd "$CONF_DIR_HOME_MANAGER"
  nix run home-manager -- --impure --flake . switch
fi

if [[ ! -e $REPO_DIR_DOTFILES ]]; then
  $GIT clone $REPO_URL_DOTFILES "$REPO_DIR_DOTFILES"
  cd "$REPO_DIR_DOTFILES"

  if [[ -e ${HOME}/.bashrc ]] && [[ ! -e ${HOME}/.bashrc.org ]]; then
    cp "${HOME}/.bashrc" "${HOME}/.bashrc.org"
  fi
  ./deploy.sh
fi
