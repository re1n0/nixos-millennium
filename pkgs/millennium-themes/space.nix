{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "space-theme-steam";
  version = "0-unstable-2026-05-06";

  src = fetchFromGitHub {
    owner = "SpaceTheme";
    repo = "Steam";
    rev = "56bc8ad50758664eb9c88572d6a22c472cb65eac";
    hash = "sha256-IJt70wwyF/LvFUEqsFjw+sYQLGOBx55BPT0bfCqU0Mg=";
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
