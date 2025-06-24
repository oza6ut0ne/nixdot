{
  lib,
  stdenvNoCC,
  git,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "diff-highlight";
  version = git.version;

  src = git;

  buildInputs = [ git ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src/share/git/contrib/diff-highlight/diff-highlight $out/bin/diff-highlight
    runHook postInstall
  '';

  meta = {
    description = "Post-processes the line-oriented diff, finds pairs
of lines, and highlights the differing segments";
    homepage = "https://git-scm.com/";
    license = lib.licenses.gpl2;
  };
})
