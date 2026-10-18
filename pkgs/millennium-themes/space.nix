{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "space-theme-steam";
  version = "20250912-unstable-2026-10-17";

  src = fetchFromGitHub {
    owner = "SpaceTheme";
    repo = "Steam";
    rev = "5b23b14bf2d0edbfe1d2e44c2b3070d6efe27f55";
    hash = "sha256-KnplhzNc4e4kmtMIFY+gf/Oe64R1vb493wbYL2vL5sM=";
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
