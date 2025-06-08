{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "blobmoji";
  version = "15.1-beta1";

  src = fetchurl {
    url = "https://github.com/C1710/blobmoji/releases/download/v${version}/Blobmoji.ttf";
    hash = "sha256-YbWI7+mWBEOoneRC/uq4Y3RN6p3RacugjGZ2LrTWlSs=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 $src $out/share/fonts/${pname}/Blobmoji.ttf
    runHook postInstall
  '';

  meta = {
    description = "Noto Emoji with extended Blob support";
    homepage = "https://github.com/C1710/blobmoji";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
