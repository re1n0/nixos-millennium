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
  pname = "proton_universal_prefix";
  version = "1.1.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "BlafKing";
    repo = "steam-proton-universal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GDTA7Xoxj/1jLxcDI8IF5DUiqQOQicRYjA5wZBoe9A4=";
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
    hash = "sha256-kQG7d6VVHwrJ1mTh8ajNz3tewYf36tztW7z68ILtYEM=";
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
    description = "A plugin that let's you use a fully universal steam Proton prefix";
    homepage = "https://github.com/BlafKing/steam-proton-universal";
    changelog = "https://github.com/BlafKing/steam-proton-universal/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [rein];
    mainProgram = "proton_universal_prefix";
    platforms = lib.platforms.all;
  };
})
