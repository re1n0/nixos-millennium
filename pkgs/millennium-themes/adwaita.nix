{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "adwaita-for-steam";
  version = "3.17";

  src = fetchFromGitHub {
    owner = "tkashkin";
    repo = "Adwaita-for-Steam";
    rev = finalAttrs.version;
    hash = "sha256-Xj8/tG/uIZZUGYv+zGxxuSlyLE7PkHo/amXy7I3jwrA=";
  };

  installPhase = ''
    runHook preInstall
    cp -r . $out
    runHook postInstall
  '';

  meta = {
    description = "Adwaita theme for the Steam client";
    homepage = "https://github.com/tkashkin/Adwaita-for-Steam";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rein ];
  };
})
