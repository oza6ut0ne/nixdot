{
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tmux-toast";
  version = "0-unstable-2026-09-01";

  src = fetchFromGitHub {
    owner = "takeshiD";
    repo = "tmux-toast";
    rev = "57a258171361753c7ad8f0471ae8f4add16eded3";
    hash = "sha256-a+wgRdn3Gv1w4uV+SY6ZhCDMvOdpSfDcN+bLevJlnWY=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 $src/scripts/tmux-toast $out/bin/tmux-toast
    runHook postInstall
  '';

  meta = {
    description = "Tmux toast plugin";
    homepage = "https://github.com/takeshiD/tmux-toast";
    mainProgram = "tmux-toast";
  };
})
