{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "minimal-dark-for-steam";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "SaiyajinK";
    repo = "Minimal-Dark-for-Steam";
    rev = finalAttrs.version;
    hash = "sha256-S5eu6omNUiou+K1yIcS4CUC3fRK/PucG6tiCHzSqmC0=";
  };

  installPhase = ''
    runHook preInstall
    cp -r . $out
    runHook postInstall
  '';

  meta = {
    description = "Minimal Dark theme for the Steam client";
    homepage = "https://github.com/SaiyajinK/Minimal-Dark-for-Steam";
    maintainers = with lib.maintainers; [ rein ];
  };
})
