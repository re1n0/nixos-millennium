{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "material-theme-steam";
  version = "0-unstable-2026-10-31";

  src = fetchFromGitHub {
    owner = "kuska1";
    repo = "Material-Theme";
    rev = "7504219cab5ccd7d01e1271c4d3ad22036cb5d3a";
    hash = "sha256-igVp+PFkBJEXpwkQPT/dE5njShuop1lSpl814PZcm/A=";
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
    maintainers = with lib.maintainers; [rein];
  };
}
