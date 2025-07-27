{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mqttcli";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "shirou";
    repo = "mqttcli";
    rev = finalAttrs.version;
    hash = "sha256-znevP93AtQ7faeYxNWxrRMUw2DLlK+6KwOGr+xvQfIY=";
  };

  vendorHash = "sha256-pqp9PBIRD1P3VDSPz1lwU+o12T+ZFjvWIDQlDXqcI7k=";

  patches = [ ./update-go-version.patch ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "MQTT Client for shell scripting";
    homepage = "https://github.com/shirou/mqttcli";
    license = lib.licenses.epl10;
    mainProgram = "mqttcli";
  };
})
