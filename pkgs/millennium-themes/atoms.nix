{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "atoms";
  version = "1.1.1.1.1.1";

  src = fetchFromGitHub {
    owner = "Plaer1";
    repo = "ATOMS";
    rev = "v${finalAttrs.version}";
    hash = "sha256-f+DkcIfiarwpEXYd+NHKlrcgAP6us23m+EXyz9SI2Rs=";
  };

  installPhase = ''
    runHook preInstall
    cp -r . $out
    runHook postInstall
  '';

  meta = {
    description = "ATOMS theme for the Steam client";
    homepage = "https://github.com/Plaer1/ATOMS";
    maintainers = with lib.maintainers; [ rein ];
  };
})
