{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "space-theme-steam";
  version = "0-unstable-2026-05-11";

  src = fetchFromGitHub {
    owner = "SpaceTheme";
    repo = "Steam";
    rev = "55d050d2a52cc76154ba7e703723cb2e99dd8afd";
    hash = "sha256-8qD5gJxVGz+Q9WvHYokQpOTrOm/PjymOTo1wNNEjFE4=";
  };

  installPhase = ''
    runHook preInstall
    cp -r . $out
    runHook postInstall
  '';

  meta = {
    description = "Space theme for the Steam client";
    homepage = "https://github.com/SpaceTheme/Steam";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rein ];
  };
}
