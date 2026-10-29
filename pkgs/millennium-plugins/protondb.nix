{
  lib,
  stdenv,
  pnpm,
  pnpmConfigHook,
  fetchPnpmDeps,
  nodejs,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "protondb";

  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "unicxrn";
    repo = "protondb-millennium";
    rev = "v${finalAttrs.version}";
    hash = "sha256-w5xP5adhKK15OXkGnSbHozA1m5ZobLA7qKSR5L8DdwE=";
  };

  nativeBuildInputs = [
    pnpm
    pnpmConfigHook
    nodejs
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit
      (finalAttrs)
      pname
      version
      src
      ;
    fetcherVersion = 4;
    hash = "sha256-3P8i75+Ni6cZIWrFOIMj9dYTOkjuhHOCCOe5cKks1RA=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/.millennium/

    cp -r .millennium/Dist $out/.millennium
    cp -r backend $out
    cp plugin.json $out
    cp README.md $out
    cp LICENSE $out

    runHook postInstall
  '';

  meta = {
    description = "A Millennium plugin that shows ProtonDB compatibility ratings on Steam store pages";
    homepage = "https://github.com/unicxrn/protondb-millennium";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [rein];
    platforms = ["x86_64-linux"];
  };
})
