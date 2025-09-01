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
  version = "unstable-2025-08-26";

  src = fetchFromGitHub {
    owner = "tmux";
    repo = "tmux";
    rev = "0c9165fc713d9297e59c210659e61ab6993b1b3e";
    hash = "sha256-PMFqIAHbMG8piTl2E7UNDvm70/qhbWTf/NNhtgI6xU0=";
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
