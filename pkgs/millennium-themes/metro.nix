{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "metro-steam";
  version = "0-unstable-2026-05-19";

  src = fetchFromGitHub {
    owner = "RoseTheFlower";
    repo = "MetroSteam";
    rev = "7955e205e8c60a3d1c3cd0851bebbcc8c35b77fa";
    hash = "sha256-Y/0aS/nFJA33z+1detz6Rgm6J7qX14Ywu98RzGLvxyM=";
  };

  installPhase = ''
    runHook preInstall
    cp -r . $out
    runHook postInstall
  '';

  meta = {
    description = "Metro theme for the Steam client";
    homepage = "https://github.com/RoseTheFlower/MetroSteam";
    maintainers = with lib.maintainers; [ rein ];
  };
}
