{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  bison,
  libevent,
  ncurses,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tmux";
  version = "unstable-2026-09-02";

  src = fetchFromGitHub {
    owner = "tmux";
    repo = "tmux";
    rev = "9fa390aee696f7c3886bc9146e4051cbbe9593cb";
    hash = "sha256-b7Zo3PGMU1Tlbj1yrSSx2gUGTdETCmPj3GkeOa/i9pQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    bison
  ];

  buildInputs = [
    ncurses
    libevent
  ];

  configureFlags = [
    "--enable-sixel"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Terminal multiplexer";
    homepage = "https://github.com/tmux/tmux";
    changelog = "https://github.com/tmux/tmux/blob/${finalAttrs.src.rev}/CHANGES";
    license = lib.licenses.bsd3;
    mainProgram = "tmux";
  };
})
