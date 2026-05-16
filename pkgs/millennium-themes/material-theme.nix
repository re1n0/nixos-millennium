{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "material-theme-steam";
  version = "0-unstable-2026-05-15";

  src = fetchFromGitHub {
    owner = "kuska1";
    repo = "Material-Theme";
    rev = "e82c41e17a26d362c30112e427a6a7204b1dbe5f";
    hash = "sha256-EEx3pre80Bwr9TgSDYxsgOKsrk4IHkA6nsC23A7070o=";
  };

  installPhase = ''
    runHook preInstall
    cp -r . $out
    runHook postInstall
  '';

  meta = {
    description = "Material Theme for the Steam client";
    homepage = "https://github.com/kuska1/Material-Theme";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rein ];
  };
}
