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
  pname = "steam-wrapped";
  version = "1.1.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "wopln";
    repo = "Steam-Wrapped";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h+tqpcFGNBCc2157biQE6dN5Gqyio8sHjZsxBfNERtU=";
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
    hash = "sha256-a/BTi0IY8gVWPBRcaH0Z/XLT5phWaEERTAtWimVLPCw=";
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
    cp plugin.json $out
    cp README.md $out
    cp LICENSE $out

    runHook postInstall
  '';

  meta = {
    description = "A native Steam gaming activity summary plugin for Millennium";
    homepage = "https://github.com/wopln/Steam-Wrapped";
    changelog = "https://github.com/wopln/Steam-Wrapped/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [rein];
    mainProgram = "steam-wrapped";
  };
})
