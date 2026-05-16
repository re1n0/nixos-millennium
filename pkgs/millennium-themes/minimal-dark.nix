{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "minimal-dark-for-steam";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "SaiyajinK";
    repo = "Minimal-Dark-for-Steam";
    rev = finalAttrs.version;
    hash = "sha256-3IZa0KuIJwR1IypcSUVdvXO6+t/0rLZxisPnW1eKQ2o=";
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
