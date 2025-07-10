{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ojichat";
  version = "0-unstable-2024-10-14";

  src = fetchFromGitHub {
    owner = "greymd";
    repo = "ojichat";
    rev = "31608b152bd546e2c79c28e8915cef0922c16c54";
    hash = "sha256-0G/41rh+KaZyFJpd7QgkTHrGu3Cymn+P8638/xeYchU=";
  };

  vendorHash = "sha256-PCe95grfSvqyDVLaRIb5ZfhtSRId8ZmiNsV0zJi0bOI=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Ojisan Nanchatte (ojichat) Generator";
    homepage = "https://github.com/greymd/ojichat";
    license = lib.licenses.mit;
    mainProgram = "ojichat";
  };
})
