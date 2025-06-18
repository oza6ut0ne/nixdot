{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "blobmoji";
  version = "15.0";

  src = fetchurl {
    url = "https://github.com/C1710/blobmoji/releases/download/v${finalAttrs.version}/Blobmoji.ttf";
    hash = "sha256-3MPWZ1A2ups171dNIiFTJ3C1vZiGy6I8ZF70aUfrePk=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 $src $out/share/fonts/${finalAttrs.pname}/Blobmoji.ttf
    runHook postInstall
  '';

  meta = {
    description = "Noto Emoji with extended Blob support";
    homepage = "https://github.com/C1710/blobmoji";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
