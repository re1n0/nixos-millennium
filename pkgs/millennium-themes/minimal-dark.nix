{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "minimal-dark-for-steam";
  version = "5.6.3";

  src = fetchFromGitHub {
    owner = "SaiyajinK";
    repo = "Minimal-Dark-for-Steam";
    rev = finalAttrs.version;
    hash = "sha256-Pixzv3U9d/kz670immAdr0JYXvoAXZHEkd3YknyYPto=";
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
