{
  lib,
  stdenvNoCC,
  symlinkJoin,
  fetchFromGitHub,
  ruby,
  skktools,
  skkDictionaries,
}:

let
  skktools-git = fetchFromGitHub {
    owner = "skk-dev";
    repo = "skktools";
    rev = "fb6a295607dbe2b5171c2c89f8a2f0b82bee9766";
    hash = "sha256-7XekxNP3nsX7FquMPHIUnyhgVbF8kwSm/4FdEiLlRj0=";
  };

  skk-emoji-jisyo = lib.sourceByRegex (fetchFromGitHub {
    owner = "uasi";
    repo = "skk-emoji-jisyo";
    rev = "v0.0.9";
    hash = "sha256-H73wfvFhff55vFvNOunkma3C28BnXGuLzMrSvTLTgXU=";
  }) [ "^SKK-JISYO\..+\.utf8$" ];

  skk-jisyo-emoji-ja = lib.sourceByRegex (fetchFromGitHub {
    owner = "ymrl";
    repo = "SKK-JISYO.emoji-ja";
    rev = "5b4df40f8ac71760816f1b2929f493505b463bd1";
    hash = "sha256-awUfIbKeFAB1NqrNPUohPJa+MLYe7TaUKkUW33lKmtc=";
  }) [ "^SKK-JISYO\..+\.utf8$" ];

  skk-base-dicts = symlinkJoin {
    name = "skk-base-dicts";
    paths = (
      map (p: p.override { useUtf8 = true; }) (
        with skkDictionaries;
        [
          l
          fullname
          geo
          jinmei
          propernoun
          station

          assoc
          edict
          law
          okinawa
          zipcode

          china_taiwan
          pinyin

          emoji
        ]
      )
      ++ [
        skk-emoji-jisyo
        skk-jisyo-emoji-ja
      ]
    );
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "skk-dicts";
  version = skkDictionaries.l.version;

  src = skk-base-dicts;

  nativeBuildInputs = [
    ruby
    skktools
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/skk

    ${ruby}/bin/ruby ${skktools-git}/filters/abbrev-convert.rb -8 -w $src/share/skk/SKK-JISYO.L.utf8 > $out/share/skk/SKK-JISYO.waei.utf8
    ${ruby}/bin/ruby ${skktools-git}/filters/abbrev-convert.rb -8 -k $src/share/skk/SKK-JISYO.L.utf8 > $out/share/skk/SKK-JISYO.hira-kata.utf8

    cp $src/SKK-JISYO.emoji-ja.utf8 $out/share/skk/
    cp $src/SKK-JISYO.emoji.utf8 $out/share/skk/SKK-JISYO.skk-emoji-jisyo.utf8
    cp $src/share/skk/SKK-JISYO.*.utf8 $out/share/skk/

    ${skktools}/bin/skkdic-expr2 \
      ${lib.concatStringsSep " + " (lib.filesystem.listFilesRecursive "${finalAttrs.src}")} \
      + $out/share/skk/SKK-JISYO.waei.utf8 + $out/share/skk/SKK-JISYO.hira-kata.utf8 \
      > $out/share/skk/SKK-JISYO.merged.utf8

    runHook postInstall
  '';

  meta = {
    description = "SKK dictionary";
    homepage = "https://github.com/skk-dev/dict";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
})
