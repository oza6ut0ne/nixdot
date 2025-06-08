{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "momiage-mono";
  version = "1.1-20221222";

  src = fetchzip {
    url = "https://github.com/kb10uy/MomiageMono/releases/download/v${version}/MomiageMono-${version}.zip";
    hash = "sha256-D/tjybo2Q2sSZmHmGyxLRq6PImL1l9p17E9oS9yL7tg=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    install -Dm644 *.ttf -t $out/share/fonts/${pname}
    runHook postInstall
  '';

  meta = {
    description = "Coding font for sidelock lovers";
    homepage = "https://github.com/kb10uy/MomiageMono";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
