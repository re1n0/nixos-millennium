{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "minimal-dark-for-steam";
  version = "6.2.6";

  src = fetchFromGitHub {
    owner = "SaiyajinK";
    repo = "Minimal-Dark-for-Steam";
    rev = finalAttrs.version;
    hash = "sha256-350W8qDEDAuB7aCbSvLx2LUwEPgHZU0QWYcnlyCXFb8=";
  };

  installPhase = ''
    runHook preInstall
    cp -r . $out
    runHook postInstall
  '';

  meta = {
    description = "Minimal Dark theme for the Steam client";
    homepage = "https://github.com/SaiyajinK/Minimal-Dark-for-Steam";
    maintainers = with lib.maintainers; [rein];
  };
})
