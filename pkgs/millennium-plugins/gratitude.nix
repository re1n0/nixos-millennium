{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  pname = "gratitude";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "BlythT";
    repo = "Gratitude-Millennium-Plugin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XRM85NMauEK9HaUl+8xkzTKy6nZxAQPeNLTN1QEMyuk=";
  };

  npmDepsHash = "sha256-MfFA/QtXakfkPNdHRI03Vp7QzC9QylZZPjYpxXbYAn8=";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/.millennium/

    cp -r .millennium/Dist $out/.millennium
    cp -r backend $out
    cp plugin.json $out
    cp LICENSE $out
    cp README.md $out

    runHook postInstall
  '';

  meta = {
    description = "A Millennium plugin for your Steam Library that adds a helpful indicator to games you have been gifted";
    homepage = "https://github.com/BlythT/Gratitude-Millennium-Plugin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [rein];
  };
})
