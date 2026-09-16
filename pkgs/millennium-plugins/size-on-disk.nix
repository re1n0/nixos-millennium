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
  pname = "size-on-disk";

  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "k0d13";
    repo = "steam-size-on-disk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-z4hV52GzxmQC6hOdYVifycmyXgD/V/7O4U9hOOietyM=";
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
    hash = "sha256-FTOXoSg6NOhbHp4r2glGoPJ9mLTp2sKcsfHl+avl9Q8=";
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
    cp CHANGELOG.md $out

    runHook postInstall
  '';

  meta = {
    description = "A Millennium plugin that allows you to instantly see the size of a game on disk";
    homepage = "https://github.com/k0d13/steam-size-on-disk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [rein];
    platforms = ["x86_64-linux"];
  };
})
