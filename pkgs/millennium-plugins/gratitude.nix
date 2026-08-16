{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  pname = "gratitude";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "BlythT";
    repo = "Gratitude-Millennium-Plugin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jb8gn5QH5g/bG3PvIiu+n6IJr6niQRBcSj4v1/8X3Z8=";
  };

  npmDepsFetcherVersion = 2;

  npmFlags = ["--legacy-peer-deps"];

  npmDepsHash = "sha256-c3+pn2y4jWQ+mSxAtBXj3VVrLfHVoB15JX2L1rFM+II=";

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
    platforms = ["x86_64-linux"];
  };
})
