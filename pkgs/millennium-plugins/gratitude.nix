{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  pname = "gratitude";

  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "BlythT";
    repo = "Gratitude-Millennium-Plugin";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Q+32LrlzRZm/RCMfFGfwbJlP065qWPRGKgkXDmzQQSo=";
  };

  npmDepsHash = "sha256-0Ak8FWwGPUvUYHmWA5w/quHBCF4DBM8o9Sn5ltlbJL4=";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/.millennium/

    cp -r .millennium/Dist $out
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
    maintainers = with lib.maintainers; [ rein ];
    platforms = [ "x86_64-linux" ];
  };
})
