{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "editprompt";
  version = "v1.6.0";

  src = fetchFromGitHub {
    owner = "eetann";
    repo = "editprompt";
    rev = "${finalAttrs.version}";
    hash = "sha256-5SPRvghiN0egkun0xOB1IwRWTlo2nctonOVBlK3PR98=";
  };

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-Bw9WoRBd/y0zorMqTlmggbAC34fYPGQ9XCfGl27dQDc=";

  npmFlags = [ "--legacy-peer-deps" ];

  meta = {
    description = "Write CLI prompts in your favorite editor";
    homepage = "https://github.com/eetann/editprompt";
    license = lib.licenses.mit;
    mainProgram = "editprompt";
  };
})
