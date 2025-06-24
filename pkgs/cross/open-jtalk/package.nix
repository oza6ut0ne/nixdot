{
  lib,
  callPackage,
  stdenv,
  fetchzip,
  hts-engine ? callPackage ./../hts-engine/package.nix { },
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "open_jtalk";
  version = "1.11";

  src = fetchzip {
    url = "https://downloads.sourceforge.net/open-jtalk/open_jtalk-${finalAttrs.version}.tar.gz";
    hash = "sha256-UEnnPXD6NlCQeIqGtPktQdzqAN35er5CvbbS5SRgqYw=";
  };

  patches = [ ./fix-dictionary-for-unknown-symbols.patch ];

  configureFlags = [
    "--with-hts-engine-header-path=${hts-engine.out}/include"
    "--with-hts-engine-library-path=${hts-engine.out}/lib"
    "--with-charset=UTF-8"
  ];

  meta = {
    description = "A Japanese text-to-speech system";
    homepage = "https://open-jtalk.sourceforge.net/";
    license = lib.licenses.bsd3;
  };
})
