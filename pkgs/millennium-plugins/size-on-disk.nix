{
  lib,
  stdenv,
  pnpm,
  pnpmConfigHook,
  fetchPnpmDeps,
  nodejs,
  fetchFromGitHub,
  autoPatchelfHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "size-on-disk";

  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "k0d13";
    repo = "steam-size-on-disk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5l08dXRIOENHEORJyyIIeQ0n/Hkbh2uChBWG2YaWvTE=";
  };

  nativeBuildInputs = [
    pnpm
    pnpmConfigHook
    nodejs
    autoPatchelfHook
  ];

  buildInputs = [stdenv.cc.cc.lib];

  pnpmDeps = fetchPnpmDeps {
    inherit
      (finalAttrs)
      pname
      version
      src
      ;
    fetcherVersion = 4;
    hash = "sha256-gJDFa4e7CQWBuc84nIGR0VoGFkoTcVPSj10lJfLgbzQ=";
  };

  buildPhase = ''
    runHook preBuild

    patchShebangs node_modules
    autoPatchelf node_modules

    pnpm exec starlight pack --release -o .millennium

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    cp .millennium/${finalAttrs.passthru.starFile} $out

    runHook postInstall
  '';

  passthru.starFile = "${finalAttrs.pname}.star";

  meta = {
    description = "A Millennium plugin that allows you to instantly see the size of a game on disk";
    homepage = "https://github.com/k0d13/steam-size-on-disk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [rein];
    platforms = ["x86_64-linux"];
  };
})
