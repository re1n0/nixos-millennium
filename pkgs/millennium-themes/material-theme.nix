{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "material-theme-steam";
  version = "0-unstable-2026-05-09";

  src = fetchFromGitHub {
    owner = "kuska1";
    repo = "Material-Theme";
    rev = "43246d9a8ce45a36c640f166dc70c81a6e8bd37c";
    hash = "sha256-4q7siXqlWCVc4z+y8QsLWDv9dVFm504ZJIJOIzkikR4=";
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
