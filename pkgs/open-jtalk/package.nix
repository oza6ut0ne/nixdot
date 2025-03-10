{
  stdenv,
  callPackage,
  hts-engine ? callPackage ./../hts-engine/package.nix { },
}:
stdenv.mkDerivation rec {
  pname = "open_jtalk";
  version = "1.11";
  meta.mainProgram = pname;
  src = builtins.fetchTarball {
    url = "http://downloads.sourceforge.net/open-jtalk/open_jtalk-1.11.tar.gz";
    sha256 = "1359c0jfblmnpm1bwyprvl0fmp215pwv91lag2850dpsf0yyfjah";
  };

  patches = ./fix-dictionary-for-unknown-symbols.patch;

  configureFlags = [
    "--with-hts-engine-header-path=${hts-engine.out}/include"
    "--with-hts-engine-library-path=${hts-engine.out}/lib"
    "--with-charset=UTF-8"
  ];
}
