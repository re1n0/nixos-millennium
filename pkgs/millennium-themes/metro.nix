{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "metro-steam";
  version = "0-unstable-2026-05-31";

  src = fetchFromGitHub {
    owner = "RoseTheFlower";
    repo = "MetroSteam";
    rev = "0b06e204982697330363a8dfb154172b00d5e589";
    hash = "sha256-tOBEqBA7kuoy6LZSDP0vnk5cxQU4TorEcskl49/cEoU=";
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
