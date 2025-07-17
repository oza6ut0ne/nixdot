{
  lib,
  buildGoModule,
  fetchFromGitHub,
  useOllama ? true,
}:

buildGoModule (finalAttrs: {
  pname = "c3tr-client";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "koron";
    repo = "c3tr-client";
    rev = "v0.0.5";
    hash = "sha256-yaGVHUoM4uCiilCa+GtKNCVRcSGehP81WbGm+u6sVkw=";
  };

  vendorHash = "sha256-KAsnSEXr+bu3WXDU8DV8suNzvaBDUMjLJH+dj5EslAA=";

  patches = lib.optionals useOllama [ ./fix-for-ollama.patch ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "A client for the C3TR Agent for Japanese-English and English-Japanese translation";
    homepage = "https://github.com/koron/c3tr-client";
    license = lib.licenses.mit;
    mainProgram = "c3tr-client";
  };
})
