{ stdenv }:
stdenv.mkDerivation {
  pname = "hts_engine";
  version = "1.10";
  src = builtins.fetchTarball {
    url =
      "https://downloads.sourceforge.net/hts-engine/hts_engine_API-1.10.tar.gz";
    sha256 = "0hbwr220wiv1nbvdvahl77061qbq3m39mj0x2bla6p5shd4x23m4";
  };
}
