{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "adwaita-for-steam";
  version = "4.4";

  src = fetchFromGitHub {
    owner = "tkashkin";
    repo = "Adwaita-for-Steam";
    rev = finalAttrs.version;
    hash = "sha256-wH0z2LZ94j5ErRI40f9IRBJXJ6yuL+NLgjmj9G8odxU=";
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
    maintainers = with lib.maintainers; [rein];
  };
})
