{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "material-theme-steam";
  version = "0-unstable-2026-05-27";

  src = fetchFromGitHub {
    owner = "kuska1";
    repo = "Material-Theme";
    rev = "b2477d1aea49974480f939170501d691406a0546";
    hash = "sha256-Tejy+meWTF+J05hsQCg5hwpNfIcbUKR4Qo4o8c9x5t8=";
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
    maintainers = with lib.maintainers; [ rein ];
  };
}
