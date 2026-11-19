{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "metro-steam";
  version = "0-unstable-2026-11-16";

  src = fetchFromGitHub {
    owner = "RoseTheFlower";
    repo = "MetroSteam";
    rev = "d3a1c1286891109043d95b793180a46a703cf73d";
    hash = "sha256-gM3zhkROVwzEqC2JZtoRbhwG8062OiY3oiZmbHE2hQM=";
  };

  installPhase = ''
    runHook preInstall
    cp -r . $out
    runHook postInstall
  '';

  meta = {
    description = "Metro theme for the Steam client";
    homepage = "https://github.com/RoseTheFlower/MetroSteam";
    maintainers = with lib.maintainers; [rein];
  };
}
