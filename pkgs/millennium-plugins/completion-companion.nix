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
  pname = "steam-completion-companion";
  version = "1.0.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "1aurens";
    repo = "steam-completion-companion";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tidOcLR+B1O6LxxqLy2pEr+tbulqbSGj/yDDfP2F2cg=";
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
    hash = "sha256-XigV2NPTYMfiRi69CwjAyYAaT3xHCoRe+Ms3M5vDwck=";
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
    description = "Millennium plugin for Steam that shows completion context for games, including achievement restrictions, estimated completion time, DLC notes, and availability warnings";
    homepage = "https://github.com/1aurens/steam-completion-companion";
    changelog = "https://github.com/1aurens/steam-completion-companion/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [rein];
    mainProgram = "steam-completion-companion";
    platforms = lib.platforms.all;
  };
})
