{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "space-theme-steam";
  version = "20250912-unstable-2026-10-25";

  src = fetchFromGitHub {
    owner = "SpaceTheme";
    repo = "Steam";
    rev = "c462be494e4987911883be4d5564bbe7660adeb5";
    hash = "sha256-qlNDEzmAikN8cOjP8iWiOwAIXhMYcWAp0nSe2BwtQtY=";
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
    maintainers = with lib.maintainers; [rein];
  };
}
