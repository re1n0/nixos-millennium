{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "space-theme-steam";
  version = "20250912-unstable-2026-09-24";

  src = fetchFromGitHub {
    owner = "SpaceTheme";
    repo = "Steam";
    rev = "a0e16ee3a6803649cd435d8dc5e45f814ab0a581";
    hash = "sha256-v58QrueTghSKIs/OjtZzNl0vX0v6zhtO51wbxYHVf4M=";
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
