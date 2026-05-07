{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "material-theme-steam";
  version = "0-unstable-2026-05-06";

  src = fetchFromGitHub {
    owner = "kuska1";
    repo = "Material-Theme";
    rev = "9dedf6298ee72e87aa612f3c5b5b405c2e86ae99";
    hash = "sha256-+uuwxsGK6dovLjAeXsNm7lUmYjBpxd3+Jq4KfXvcV7g=";
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
