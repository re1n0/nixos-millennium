{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "metro-steam";
  version = "0-unstable-2026-06-03";

  src = fetchFromGitHub {
    owner = "RoseTheFlower";
    repo = "MetroSteam";
    rev = "e21277c2607b6b1247b4985407e9db3f7cca1292";
    hash = "sha256-t1YFImILtS6KwUw7YgPDkfg5d9qLdPf9pSH0uxeHJhE=";
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
