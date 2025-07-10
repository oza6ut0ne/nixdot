{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  makeWrapper,
  libappindicator-gtk3,
}:

let
  scriptCopyIcons = ''
    dst_dir=\"\''${HOME}/.config/runcat/icons\"
    if [ ! -d \"\''${dst_dir}\" ]; then
      mkdir -p \"\''${dst_dir}\"
      cp -r -T \"$out/icons\" \"\''${dst_dir}\"
      chmod -R u+w \"\''${dst_dir}\"
    fi
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "runcat-tray";
  version = "0-unstable-2024-04-23";

  src = fetchFromGitHub {
    owner = "chux0519";
    repo = "runcat-tray";
    rev = "9fe316b36d5fd0c14fcdc539f5b084df7f618b10";
    hash = "sha256-Gq8FhBnvWEx+g9R7QkAb4cAT/cn8Mk6gAfnH+viwb+s=";
  };

  patches = [ ./do-not-install-icons.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libappindicator-gtk3
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 /build/source/build/runcat $out/bin/runcat
    strip $out/bin/runcat
    cp -r -T $src/icons $out/icons
    wrapProgram $out/bin/runcat --run "${scriptCopyIcons}"
    runHook postInstall
  '';

  meta = {
    description = "Runcat system tray on Linux";
    homepage = "https://github.com/chux0519/runcat-tray";
    license = lib.licenses.bsd2;
    mainProgram = "runcat";
  };
})
