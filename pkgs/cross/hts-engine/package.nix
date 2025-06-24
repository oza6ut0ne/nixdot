{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hts_engine";
  version = "1.10";

  src = fetchzip {
    url = "https://downloads.sourceforge.net/hts-engine/hts_engine_API-${finalAttrs.version}.tar.gz";
    hash = "sha256-pA7RSYO6XKPoEh3ImkYdeOFgwDkUqt32smFHDoTIfEE=";
  };

  patches = lib.optionals stdenv.hostPlatform.isMusl [ ./fix-for-musl.patch ];

  meta = {
    description = "Software to synthesize speech waveform from HMMs trained by the HMM-based speech synthesis system (HTS)";
    homepage = "https://hts-engine.sourceforge.net/";
    license = lib.licenses.bsd3;
  };
})
